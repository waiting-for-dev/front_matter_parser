# frozen_string_literal: true

require 'spec_helper'
require 'front_matter_parser/syntax_writer/indentation_comment'

describe FrontMatterParser::SyntaxWriter::IndentationComment do
  subject(:generated) { FrontMatterParser::Writer.new(syntax).call(parsed) }

  let(:parsed) { FrontMatterParser::Parsed.new(front_matter: front_matter, content: content) }
  let(:front_matter) { { 'title' => 'hello', 'author' => 'me' } }
  let(:content) { "Content\n" }

  context 'when syntax is slim' do
    let(:syntax) { :slim }
    it do
      is_expected.to eq <<~STRING
        /
          ---
          title: hello
          author: me
          ---
        Content
      STRING
    end
  end

  context 'when syntax is haml' do
    let(:syntax) { :haml }
    it do
      is_expected.to eq <<~STRING
        -#
          ---
          title: hello
          author: me
          ---
        Content
      STRING
    end
  end

  context 'with comment delimiter in the front matter' do
    let(:syntax) { :slim }
    let(:front_matter) { { 'title' => '/hello', 'author' => 'me' } }
    it do
      is_expected.to eq <<~STRING
        /
          ---
          title: "/hello"
          author: me
          ---
        Content
      STRING
    end
  end

  context 'with front matter delimiter chars in the content' do
    let(:syntax) { :slim }
    let(:content) { "Content\n---\n" }
    it do
      is_expected.to eq <<~STRING
        /
          ---
          title: hello
          author: me
          ---
        Content
        ---
      STRING
    end
  end
end
