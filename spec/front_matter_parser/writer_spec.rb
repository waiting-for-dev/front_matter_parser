# frozen_string_literal: true

require 'spec_helper'
require 'front_matter_parser/writer'

describe FrontMatterParser::Writer do
  subject(:writer) { described_class.new(syntax) }

  let(:syntax) { FrontMatterParser::SyntaxParser::Html.new }
  let(:parsed) { FrontMatterParser::Parsed.new(front_matter: front_matter, content: content) }
  let(:front_matter) { { 'title' => 'hello' } }
  let(:content) { "Content\n" }

  describe '#call' do
    subject(:generated) { writer.call(parsed) }
    let(:string) do
      <<~STRING
        <!--
        ---
        title: hello
        ---
        -->
        Content
      STRING
    end

    context 'when parser given' do
      let(:syntax) { FrontMatterParser::SyntaxParser::Html.new }

      it { is_expected.to eq string }
    end

    context 'when symbol given' do
      let(:syntax) { :html }

      it { is_expected.to eq string }
    end

    context 'when front_matter is empty' do
      let(:front_matter) { {} }
      let(:syntax) { :html }

      it 'writes front matter as an empty hash if it is not present' do
        is_expected.to eq <<~STRING
          <!--
          --- {}
          ---
          -->
          Content
        STRING
      end
    end

    context 'when dumper provided' do
      let(:writer) { described_class.new(syntax, dumper: dumper) }
      let(:dumper) { ->(_hash) { "---\n~*~*~" } }

      it do
        is_expected.to eq <<~STRING
        <!--
        ---
        ~*~*~
        ---
        -->
        Content
        STRING
      end
    end
  end

  describe '.write_file' do
    subject(:output) { described_class.write_file(output_filename, parsed, **options) }

    let(:options) { {} }
    let(:parsed) { FrontMatterParser::Parser.parse_file(input_filename, syntax_parser: syntax_parser) }
    let(:syntax_parser) { nil }
    let(:input_filename) { File.expand_path("../fixtures/#{file}", __dir__) }
    let(:output_filename) { File.expand_path("../output/#{file}", __dir__) }
    let(:file) { 'example.html' }
    let(:expected_output) do
      <<~HTML
        <!--
        ---
        title: hello
        ---
        -->
        Content
      HTML
    end

    context 'when inferring syntax from given pathname' do
      it { is_expected.to eq expected_output }
    end

    context 'when syntax_parser specified' do
      let(:syntax_parser) { FrontMatterParser::SyntaxParser::Html.new }

      it { is_expected.to eq expected_output }
    end

    context 'when syntax_parser specified as symbol' do
      let(:syntax_parser) { :html }

      it { is_expected.to eq expected_output }
    end

    context 'when dumper: specified' do
      let(:options) { { dumper: ->(_string) { "---\n~*~*~*~" } } }

      it do
        is_expected.to eq <<~HTML
          <!--
          ---
          ~*~*~*~
          ---
          -->
          Content
        HTML
      end
    end
  end
end
