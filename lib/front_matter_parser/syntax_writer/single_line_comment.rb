# frozen_string_literal: true

require_relative 'interface'

module FrontMatterParser
  module SyntaxWriter
    # Parser for syntaxes which use comments ended by indentation
    class SingleLineComment < Interface
      # @see SyntaxWriter
      def call(front_matter:, content:)
        front_matter = add_delimeter(front_matter, delimiters.first)
        super(front_matter: front_matter, content: content)
      end

      private

      def add_delimeter(string, delimiter)
        string.gsub(/^/, "#{delimiter} ")
      end

      def build_template(delimiter)
        <<~END
        %{front_matter}
        #{delimiter} ---
        %{content}
        END
      end
    end
  end
end
