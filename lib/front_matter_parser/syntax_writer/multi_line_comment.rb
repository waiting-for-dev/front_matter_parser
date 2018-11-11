# frozen_string_literal: true

require_relative 'interface'

module FrontMatterParser
  module SyntaxWriter
    # Parser for syntaxes which use end and finish comment delimiters
    class MultiLineComment < Interface
      private

      def build_template(*delimeters)
        delimeters = [nil, nil] if delimeters.all?(&:empty?)
        start_delimiter, end_delimiter = delimeters
        [start_delimiter, "%{front_matter}\n---", end_delimiter, '%{content}'].compact.join("\n")
      end
    end
  end
end
