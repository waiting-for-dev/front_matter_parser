# frozen_string_literal: true

require_relative "parser"
require_relative "dumper"
require_relative "syntax_writer"

module FrontMatterParser
  # Entry point to parse a front matter from a string or file.
  class Writer < Parser
    # @!attribute [r] dumper
    # Current dumper in use. See {Dumper} for details
    attr_reader :dumper
    attr_reader :syntax_writer

    class << self
      def write_file(pathname, parsed, syntax_parser: nil, **options)
        syntax_parser ||= syntax_from_pathname(pathname)
        new(syntax_parser, **options).call(parsed).tap do |output|
          File.write(pathname, output)
        end
      end
    end

    # @param syntax_parser [Object] Syntax parser to use. It can be one of two
    #   things:
    #
    #   - An actual object which acts like a parser. See {SyntaxParser} for
    #   details.
    #
    #   - A symbol, in which case it refers to a parser
    #   `FrontMatterParser::SyntaxParser::#{symbol.capitalize}` which can be
    #   initialized without arguments
    #
    # @param loader [Object] Front matter loader to use. See {Loader} for
    # details.
    def initialize(syntax_parser, dumper: Dumper::Yaml.new, **opts)
      super(syntax_parser, **opts)
      @dumper = dumper
      @syntax_writer = SyntaxWriter.writer_for(@syntax_parser.class)
    end

    # Parses front matter and content from given string
    #
    # @param string [String]
    # @return [Parsed] parsed front matter and content
    # :reek:FeatureEnvy
    def call(parsed)
      front_matter, content = parsed.front_matter, parsed.content
      front_matter = dumper.(front_matter)
      syntax_writer.(front_matter: front_matter, content: content)
    end
  end
end
