# frozen_string_literal: true

require 'front_matter_parser/syntax_parser'
require 'front_matter_parser/syntax_writer/multi_line_comment'
require 'front_matter_parser/syntax_writer/indentation_comment'
require 'front_matter_parser/syntax_writer/single_line_comment'

module FrontMatterParser
  # This module includes parsers for different syntaxes.  They respond to
  # a method `#call`, which takes a string as argument and responds with
  # a hash interface with `:front_matter` and `:content` keys, or `nil` if no
  # front matter is found.
  #
  # :reek:TooManyConstants
  module SyntaxWriter
    def self.writer_for(syntax_parser)
      parser_type = syntax_parser.superclass.name.split('::').last
      const_get(parser_type).new(syntax_parser)
    end

    SyntaxParser.constants.each do |constant|
      parser = SyntaxParser.const_get(constant)
      next unless parser.is_a?(Class)
      next if parser.superclass == Object
      parser = writer_for(parser)
      const_set(constant, parser)
    end
  end
end
