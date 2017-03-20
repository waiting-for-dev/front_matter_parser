# frozen_string_literal: true

require 'spec_helper'

describe FrontMatterParser::SyntaxParser::SingleLineComment do
  let(:front_matter) { { 'title' => 'hello', 'author' => 'me' } }
  let(:content) { "Content\n" }

  subject(:parsed) { FrontMatterParser::Parser.new(syntax).call(string) }

  context 'coffee' do
    let(:syntax) { :coffee }
    let(:string) do
      <<~eos
        #---
        #title: hello
        #author: me
        #---
        Content
        eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'sass' do
    let(:syntax) { :sass }
    let(:string) do
      <<~eos
        //---
        //title: hello
        //author: me
        //---
        Content
        eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'scss' do
    let(:syntax) { :scss }
    let(:string) do
      <<~eos
        //---
        //title: hello
        //author: me
        //---
        Content
        eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space before comment delimiters' do
    let(:syntax) { :coffee }
    let(:string) do
      <<~eos
         #---
         #title: hello
         #author: me
         #---
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space between comment delimiters and front matter' do
    let(:syntax) { :coffee }
    let(:string) do
      <<~eos
        # ---
        # title: hello
        # author: me
        # ---
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space between front matter' do
    let(:syntax) { :coffee }
    let(:string) do
      <<~eos
        # ---
        #   title: hello
        #
        #   author: me
        # ---
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with uncommented lines between front matter' do
    let(:syntax) { :coffee }
    let(:string) do
      <<~eos
        # ---
        #   title: hello

        #   author: me
        # ---
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with comment delimiter in the front matter' do
    let(:syntax) { :sass }
    let(:string) do
      <<~eos
        //---
        //title: //hello
        //author: me
        //---
        Content
      eos
    end

    it 'can parse it' do
      front_matter = { 'title' => '//hello', 'author' => 'me' }

      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end
end
