# frozen_string_literal: true

require 'spec_helper'

describe FrontMatterParser::SyntaxParser::MultiLineComment do
  subject(:parsed) { FrontMatterParser::Parser.new(syntax).call(string) }

  let(:front_matter) { { 'title' => 'hello', 'author' => 'me' } }
  let(:content) { "Content\n" }

  context 'html' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!--
        ---
        title: hello
        author: me
        ---
        -->
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'erb' do
    let(:syntax) { :erb }
    let(:string) do
      <<~eos
        <%#
        ---
        title: hello
        author: me
        ---
        %>
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'liquid' do
    let(:syntax) { :liquid }
    let(:string) do
      <<~eos
        {% comment %}
        ---
        title: hello
        author: me
        ---
        {% endcomment %}
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'md' do
    let(:syntax) { :md }
    let(:string) do
      <<~eos
        ---
        title: hello
        author: me
        ---
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space before start comment delimiter' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos

           <!--
        ---
        title: hello
        author: me
        ---
        -->
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with front matter starting in comment delimiter line' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!-- ---
        title: hello
        author: me
        ---
        -->
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space before front matter' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!--

           ---
        title: hello
        author: me
        ---
        -->
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space between front matter' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!--
        ---
          title: hello

          author: me
        ---
        -->
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space after front matter' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!--
        ---
        title: hello
        author: me
        ---

        -->
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with space before end comment delimiter' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!--
        ---
        title: hello
        author: me
        ---
           -->
        Content
      eos
    end

    it 'can parse it' do
      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with start comment delimiter in the front matter' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!--
        ---
        title: <!--hello
        author: me
        ---
           -->
        Content
      eos
    end

    it 'can parse it' do
      front_matter = { 'title' => '<!--hello', 'author' => 'me' }

      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end

  context 'with start and end comment delimiter in the front matter' do
    let(:syntax) { :html }
    let(:string) do
      <<~eos
        <!--
        ---
        title: <!--hello-->
        author: me
        ---
           -->
        Content
      eos
    end

    it 'can parse it' do
      front_matter = { 'title' => '<!--hello-->', 'author' => 'me' }

      expect(parsed).to be_parsed_result_with(front_matter, content)
    end
  end
end
