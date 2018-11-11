# frozen_string_literal: true

require_relative 'interface'

module FrontMatterParser
  module SyntaxWriter
    # Common interface for syntas writers
    class Interface
      # @!attribute [r] template
      # A template that accepts substitutions: front_matter and content
      attr_reader :template

      def initialize(syntax_parser)
        @syntax_parser = syntax_parser
        @template = build_template(*delimiters).chomp
      end

      # @see SyntaxWriter
      def call(front_matter:, content:)
        template.gsub(/%\{(front_matter|content)\}/, '%{front_matter}' => front_matter, '%{content}' => content)
      end

      private

      def delimiters
        @delimeters = @syntax_parser.delimiters.map(&method(:unescape))
      end

      def unescape(string)
        string.gsub(%r{\\(.)}, '\1')
      end

      def build_template(start_delimiter, end_delimiter)
        raise NotImplementedError
      end
    end
  end
end
