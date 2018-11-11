# frozen_string_literal: true

require_relative 'interface'

module FrontMatterParser
  module SyntaxWriter
    # Parser for syntaxes which use comments ended by indentation
    class IndentationComment < Interface
      # @see SyntaxWriter
      def call(front_matter:, content:)
        front_matter = indent(front_matter)
        super(front_matter: front_matter, content: content)
      end

      private

      def indent(string, indent = "  ")
        string.gsub(/^/, indent)
      end

      def build_template(delimiter)
        <<~END
        #{delimiter}
        %{front_matter}
          ---
        %{content}
        END
      end
    end
  end
end
