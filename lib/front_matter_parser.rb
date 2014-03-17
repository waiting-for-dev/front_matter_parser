require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

# FrontMatterParser module is the entry point to parse strings or files with YAML front matters. When working with files, it can automatically detect the syntax of a file from its extension and it supposes that the front matter is marked as that syntax comments.
module FrontMatterParser
  # {Hash {Symbol => Array}} Comments delimiters used in FrontMatterParser known syntaxes. Keys are file extensions, and values are three elements array:
  #
  # * First element is single line comment delimiter.
  # * Second element is the start multiline comment delimiter.
  # * Third element is the end multiline comment delimiter. If it is `nil` and start multiline comment delimiter isn't, it means that the comment is closed by indentation.
  COMMENT_DELIMITERS = {
    slim: [nil, '/', nil],
    html: [nil, '<!--', '-->'],
    coffee: ['#', nil, nil],
    haml: [nil, '-#', nil],
    liquid: [nil, '<% comment %>', '<% endcomment %>'],
    sass: ['//', nil, nil],
    scss: ['//', nil, nil],
    md: [nil, nil, nil],
  }

  # Parses a string into a {Parsed} instance. For comment options, see {COMMENT_DELIMITERS} values (but they are not limited to those for the known syntaxes).
  #
  # @param string [String] The string to parse
  # @param opts [Hash] Options
  # @option opts [String, nil] :comment Single line comment delimiter
  # @option opts [String, nil] :start_comment Start multiline comment delimiter
  # @option opts [String, nil] :end_comment End multiline comment delimiter
  # @return [Parsed]
  # @raise [ArgumentError] If end_comment option is provided but not start_comment
  # @see COMMENT_DELIMITERS
  def self.parse(string, opts = {})
    opts = {
      comment: nil,
      start_comment: nil,
      end_comment: nil,
    }.merge(opts)
    raise(ArgumentError, "If you provide the `end_comment` option, you must provide also the `start_comment` option") if (opts[:end_comment] != nil and opts[:start_comment] == nil)
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
      front_matter = matches[:front_matter].gsub(/^#{opts[:comment]}/, '')
      parsed.front_matter = YAML.load(front_matter)
      parsed.content = matches[:content]
    else
      parsed.front_matter = {}
      parsed.content = string
    end
    parsed
  end

  # Parses a file into a {Parsed} instance. If autodetect option is `true`, comment delimiters are guessed from the file extension. If it is `false` comment options are taken into consideration. See {COMMENT_DELIMITERS} for a list of known syntaxes and the comment delimiters values.
  #
  # @param pathname [String] The path to the file
  # @param opts [Hash] Options
  # @option opts [Boolean] :autodetect If it is true, FrontMatterParser uses the comment delimiters known for the syntax of the file and comment options are ignored. If it is false, comment options are taken into consideration.
  # @option opts [String, nil] :comment Single line comment delimiter
  # @option opts [String, nil] :start_comment Start multiline comment delimiter
  # @option opts [String, nil] :end_comment End multiline comment delimiter
  # @return [Parsed]
  # @raise [ArgumentError] If autodetect option is false, and start_comment option is provided but not end_comment
  # @raise [RuntimeError] If the syntax of the file (the extension) is not within the keys of {COMMENT_DELIMITERS}
  # @see COMMENT_DELIMITERS
  def self.parse_file(pathname, opts={})
    opts = {
      autodetect: true,
      comment: nil,
      start_comment: nil,
      end_comment: nil,
    }.merge(opts)
    if opts[:autodetect]
      ext = File.extname(pathname)[1 .. -1].to_sym
      raise(RuntimeError, "Comment delimiters for extension #{ext.to_s} not known. Please, call #parse_file without autodetect option and provide comment delimiters.") unless COMMENT_DELIMITERS.has_key?(ext)
      comment_delimiters = COMMENT_DELIMITERS[ext]
      opts[:comment] = comment_delimiters[0]
      opts[:start_comment] = comment_delimiters[1]
      opts[:end_comment] = comment_delimiters[2]
    end
    File.open(pathname) do |file|
      parse(file.read, comment: opts[:comment], start_comment: opts[:start_comment], end_comment: opts[:end_comment])
    end
  end
end
