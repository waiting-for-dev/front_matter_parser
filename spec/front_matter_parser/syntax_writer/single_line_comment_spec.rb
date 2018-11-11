# frozen_string_literal: true

require 'spec_helper'
require 'front_matter_parser/syntax_writer/single_line_comment'

describe FrontMatterParser::SyntaxParser::SingleLineComment do
  subject(:generated) { FrontMatterParser::Writer.new(syntax).call(parsed) }

  let(:parsed) { FrontMatterParser::Parsed.new(front_matter: front_matter, content: content) }
  let(:front_matter) { { 'title' => 'hello', 'author' => 'me' } }
  let(:content) { "Content\n" }

  context 'when syntax is coffee' do
    let(:syntax) { :coffee }
    it do
      is_expected.to eq <<~STRING
        # ---
        # title: hello
        # author: me
        # ---
        Content
      STRING
    end
  end

  context 'when syntax is ruby' do
    let(:syntax) { :rb }
    it do
      is_expected.to eq <<~STRING
        # ---
        # title: hello
        # author: me
        # ---
        Content
      STRING
    end
  end

  context 'when syntax is sass' do
    let(:syntax) { :sass }
    it do
      is_expected.to eq <<~STRING
        // ---
        // title: hello
        // author: me
        // ---
        Content
      STRING
    end
  end

  context 'when syntax is scss' do
    let(:syntax) { :scss }
    it do
      is_expected.to eq <<~STRING
        // ---
        // title: hello
        // author: me
        // ---
        Content
      STRING
    end
  end

  context 'with space between comment delimiters and front matter' do
    let(:syntax) { :coffee }
    it do
      is_expected.to eq <<~STRING
        # ---
        # title: hello
        # author: me
        # ---
        Content
      STRING
    end
  end

  context 'with comment delimiter in the front matter' do
    let(:front_matter) { { 'title' => '//hello', 'author' => 'me' } }
    let(:syntax) { :sass }
    it do
      is_expected.to eq <<~STRING
        // ---
        // title: "//hello"
        // author: me
        // ---
        Content
      STRING
    end
  end

  context 'with front matter delimiter chars in the content' do
    let(:front_matter) { { 'title' => 'hello' } }
    let(:content) { "// ---\nContent\n" }
    let(:syntax) { :sass }
    it do
      is_expected.to eq <<~STRING
        // ---
        // title: hello
        // ---
        // ---
        Content
      STRING
    end
  end
end
