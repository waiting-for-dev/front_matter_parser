require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

# FrontMatterParser module is the entry point to parse strings or files with YAML front matters. When working with files, it can automatically detect the syntax of a file from its extension and it supposes that the front matter is marked as that syntax comments.
module FrontMatterParser
  # {Hash {Symbol => Array}} Comments delimiters for FrontMatterParser known syntaxes. Keys are file extensions for {FrontMatterParser.parse_file} or :syntax option values for {FrontMatterParser.parse}, and values are three elements array:
  #
  # * First element is single line comment delimiter.
  # * Second element is the start multiline comment delimiter.
  # * Third element is the end multiline comment delimiter. If it is `nil` and start multiline comment delimiter isn't, it means that the comment is closed by indentation.
  COMMENT_DELIMITERS = {
    slim: [nil, '/', nil],
    html: [nil, '<!--', '-->'],
    erb: [nil, '<%#', '%>'],
    coffee: ['#', nil, nil],
    haml: [nil, '-#', nil],
    liquid: [nil, '{% comment %}', '{% endcomment %}'],
    sass: ['//', nil, nil],
    scss: ['//', nil, nil],
    md: [nil, nil, nil],
  }

  # Parses a string into a {Parsed} instance. The syntax of the string can be set with :syntax option. Otherwise, comment marks can be manually indicated with :comment, :start_comment and :end_comment options.
  #
  # @param string [String] The string to parse
  # @param opts [Hash] Options
  # @option opts [Symbol] :syntax The syntax used in the string. See {FrontMatterParser::COMMENT_DELIMITERS} for allowed values and the comment delimiters that are supposed.
  # @option opts [String, nil] :comment Single line comment delimiter
  # @option opts [String, nil] :start_comment Start multiline comment delimiter
  # @option opts [String, nil] :end_comment End multiline comment delimiter. If it is `nil` and :start_comment isn't, the multiline comment is supposed to be closed by indentation
  # @return [Parsed]
  # @raise [ArgumentError] If :syntax is not within {COMMENT_DELIMITERS} keys
  # @raise [ArgumentError] If :end_comment option is given but not :start_comment
  # @raise [ArgumentError] If :comment and :start_comment options are given
  # @see COMMENT_DELIMITERS
  def self.parse(string, opts = {})
    opts = {
      comment: nil,
      start_comment: nil,
      end_comment: nil,
      syntax: nil,
    }.merge(opts)

    raise(ArgumentError, "If you provide :end_comment, you must also provide :start_comment") if (opts[:end_comment] != nil and opts[:start_comment] == nil)
    raise(ArgumentError, "You can not provide :comment and :start_comment options at the same time") if (opts[:start_comment] != nil and opts[:comment] != nil)

    if opts[:comment].nil? and opts[:start_comment].nil? and not opts[:syntax].nil?
      raise(ArgumentError, "#{opts[:syntax]} syntax not known. Please call parse providing manually comment delimiters for that syntax.") unless COMMENT_DELIMITERS.has_key?(opts[:syntax])
      opts[:comment], opts[:start_comment], opts[:end_comment] = COMMENT_DELIMITERS[opts[:syntax]]
    end

    parsed = Parsed.new
    if matches = (string.match(/
                               # Start of string
                               \A
                               # Zero or more space characters
                               ([[:space:]]*)
                               # Start multiline comment
                               #{'(?-x:(?<multiline_comment_indentation>^[[:blank:]]*)'+opts[:start_comment]+'[[:blank:]]*[\n\r][[:space:]]*)' unless opts[:start_comment].nil?}
                               # Begin front matter
                               (?-x:^[[:blank:]]*#{opts[:comment]}[[:blank:]]*---[[:blank:]]*$[\n\r])
                               # The front matter
                               (?<front_matter>.*)
                               # End front matter
                               (?-x:^[[:blank:]]*#{opts[:comment]}[[:blank:]]*---[[:blank:]]*$[\n\r])
                               # End multiline comment
                               #{'(?-x:\k<multiline_comment_indentation>)' if opts[:end_comment].nil? and not opts[:start_comment].nil?}
                               #{'(?-x:[[:space:]]*^[[:blank:]]*'+opts[:end_comment]+'[[:blank:]]*[\n\r])' if not opts[:end_comment].nil?}
                               # The content
                               (?<content>.*)
                               # End of string
                               \z
                               /mx))
      front_matter = matches[:front_matter].gsub(/^[[:blank:]]*#{opts[:comment]}/, '')
      parsed.front_matter = YAML.load(front_matter)
      parsed.content = matches[:content]
    else
      parsed.front_matter = {}
      parsed.content = string
    end
    parsed
  end

  # Parses a file into a {Parsed} instance. Syntax is automatically guessed from the file extension, unless :comment, :start_comment or :end_comment options are given. See {COMMENT_DELIMITERS} for a list of known extensions and the comment delimiters values that are supposed.
  #
  # @param pathname [String] The path to the file
  # @param opts [Hash] Options
  # @option opts [String, nil] :comment Single line comment delimiter
  # @option opts [String, nil] :start_comment Start multiline comment delimiter
  # @option opts [String, nil] :end_comment End multiline comment delimiter. If it is `nil`, the multiline comment is supposed to be closed by indentation.
  # @return [Parsed]
  # @raise [ArgumentError] If :start_comment option is provided but not :end_comment
  # @raise [ArgumentError] If :comment and :start_comment options are both provided
  # @raise [ArgumentError] If :end_comment is provided but :start_comment isn't
  # @raise [RuntimeError] If the syntax of the file (the extension) is not within the keys of {COMMENT_DELIMITERS} or the file has no extension, and none of :comment, :start_comment or :end_comment are provided
  # @see COMMENT_DELIMITERS
  def self.parse_file(pathname, opts={})
    opts = {
      comment: nil,
      start_comment: nil,
      end_comment: nil,
    }.merge(opts)
    if opts[:comment].nil? and opts[:start_comment].nil?
      ext = File.extname(pathname)[1 .. -1]
      ext = ext.to_sym unless ext.nil?
      raise(RuntimeError, "Comment delimiters for extension #{ext.to_s} not known. Please, call #parse_file providing manually comment delimiters for that extension.") unless COMMENT_DELIMITERS.has_key?(ext)
      File.open(pathname) do |file|
        parse(file.read, syntax: ext)
      end
    else
      File.open(pathname) do |file|
        parse(file.read, comment: opts[:comment], start_comment: opts[:start_comment], end_comment: opts[:end_comment])
      end
    end
  end
end
