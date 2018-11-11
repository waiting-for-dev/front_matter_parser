# frozen_string_literal: true

require 'spec_helper'
require 'front_matter_parser/syntax_writer/multi_line_comment'

describe FrontMatterParser::SyntaxParser::MultiLineComment do
  subject(:generated) { FrontMatterParser::Writer.new(syntax).call(parsed) }

  let(:parsed) { FrontMatterParser::Parsed.new(front_matter: front_matter, content: content) }
  let(:front_matter) { { 'title' => 'hello', 'author' => 'me' } }
  let(:content) { "Content\n" }

  context 'when syntax is html' do
    let(:syntax) { :html }
    it do
      is_expected.to eq <<~STRING
        <!--
        ---
        title: hello
        author: me
        ---
        -->
        Content
      STRING
    end
  end

  context 'when syntax is erb' do
    let(:syntax) { :erb }
    it do
      is_expected.to eq <<~STRING
        <%#
        ---
        title: hello
        author: me
        ---
        %>
        Content
      STRING
    end
  end

  context 'when syntax is liquid' do
    let(:syntax) { :liquid }
    it do
      is_expected.to eq <<~STRING
        {% comment %}
        ---
        title: hello
        author: me
        ---
        {% endcomment %}
        Content
      STRING
    end
  end

  context 'when syntax is md' do
    let(:syntax) { :md }
    it do
      is_expected.to eq <<~STRING
        ---
        title: hello
        author: me
        ---
        Content
      STRING
    end
  end

  context 'with start comment delimiter in the front matter' do
    let(:syntax) { :html }
    let(:front_matter) { { 'title' => '<!--hello', 'author' => 'me' } }
    it do
      is_expected.to eq <<~STRING
        <!--
        ---
        title: "<!--hello"
        author: me
        ---
        -->
        Content
      STRING
    end
  end

  context 'with start and end comment delimiter in the front matter' do
    let(:syntax) { :html }
    let(:front_matter) { { 'title' => '<!--hello-->', 'author' => 'me' } }
    it do
      is_expected.to eq <<~STRING
        <!--
        ---
        title: "<!--hello-->"
        author: me
        ---
        -->
        Content
      STRING
    end
  end

  context 'with front matter delimiter chars in the content' do
    let(:syntax) { :md }
    let(:front_matter) { { 'title' => 'hello' } }
    let(:content) { "Content---\n" }
    it do
     is_expected.to eq <<~STRING
        ---
        title: hello
        ---
        Content---
      STRING
    end
  end
end
