require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

# 
# FrontMatterParser module is the entry point to parse strings or file with YAML front matters. When working with files, it can automatically detect the syntax of a file from its extension and it supposes that the front matter is marked as comments.
module FrontMatterParser
  # {Hash {Symbol => Array}} Comments delimiters used in FrontMatterParser known syntaxs. Keys are file extensions, and values are three elements array:
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
  }

  # Parses a string into a {Parsed} instance. For the meaning of comment delimiters, see {COMMENT_DELIMITERS} values (but they are not limited to those for the known syntaxs).
  #
  # @param string [String] The string to parse
  # @param comment_delimiter [String, nil] Single line comment delimiter
  # @param start_multiline_comment_delimiter [String, nil] Start multiline comment delimiter
  # @param end_multiline_comment_delimiter [String, nil] End multiline comment delimiter
  # @return [Parsed]
  # @raise [ArgumentError] If end_multiline_comment_delimiter is provided but not start_multiline_comment_delimiter
  # @see COMMENT_DELIMITERS
  def self.parse(string, comment_delimiter = nil, start_multiline_comment_delimiter = nil, end_multiline_comment_delimiter = nil)
    raise(ArgumentError, 'If you provide the end_multiline_comment_delimiter, you must provide start_multiline_comment_delimiter') if (end_multiline_comment_delimiter != nil and start_multiline_comment_delimiter == nil)
    parsed = Parsed.new
    if matches = (string.match(/
                               # Start of string
                               \A
                               # Zero or more space characters
                               ([[:space:]]*)
                               # Start multiline comment
                               #{'(?-x:(?<multiline_comment_indentation>^[[:blank:]]*)'+start_multiline_comment_delimiter+'[[:blank:]]*[\n\r][[:space:]]*)' unless start_multiline_comment_delimiter.nil?}
                               # Begin front matter
                               (?-x:^[[:blank:]]*#{comment_delimiter}[[:blank:]]*---[[:blank:]]*$[\n\r])
                               # The front matter
                               (?<front_matter>.*)
                               # End front matter
                               (?-x:^[[:blank:]]*#{comment_delimiter}[[:blank:]]*---[[:blank:]]*$[\n\r])
                               # End multiline comment
                               #{'(?-x:\k<multiline_comment_indentation>)' if end_multiline_comment_delimiter.nil? and not start_multiline_comment_delimiter.nil?}
                               #{'(?-x:[[:space:]]*^[[:blank:]]*'+end_multiline_comment_delimiter+'[[:blank:]]*[\n\r])' if not end_multiline_comment_delimiter.nil?}
                               # The content
                               (?<content>.*)
                               # End of string
                               \z
                               /mx))
      front_matter = matches[:front_matter].gsub(/^#{comment_delimiter}/, '')
      parsed.front_matter = YAML.load(front_matter)
      parsed.content = matches[:content]
    else
      parsed.front_matter = {}
      parsed.content = string
    end
    parsed
  end

  # Parses a file into a {Parsed} instance. If `autodetect` is `true`, comment delimiters are guessed from the file extension. If it is `false` the rest of attributes are taken into consideration. See {COMMENT_DELIMITERS} to a list of known syntaxs and the comment delimiters values.
  #
  # @param pathname [String] The path to the file
  # @param autodetect [Boolean] If it is true, FrontMatterParser uses the comment delimiters known for the syntax of the file and the rest of arguments are ignored. If it is false, the rest of arguments are taken into consideration.
  # @param comment_delimiter [String, nil] Single line comment delimiter
  # @param start_multiline_comment_delimiter [String, nil] Start multiline comment delimiter
  # @param end_multiline_comment_delimiter [String, nil] End multiline comment delimiter
  # @return [Parsed]
  # @raise [ArgumentError] If autodetect is false, and end_multiline_comment_delimiter is provided but not start_multiline_comment_delimiter
  # @raise [RuntimeError] If the syntax of the file (the extension) is not within the keys of {COMMENT_DELIMITERS}
  # @see COMMENT_DELIMITERS
  def self.parse_file(pathname, autodetect = true, comment_delimiter = nil, start_multiline_comment_delimiter = nil, end_multiline_comment_delimiter = nil)
    if autodetect
      ext = File.extname(pathname)[1 .. -1].to_sym
      raise(RuntimeError, "Comment delimiters for extension #{ext.to_s} not known. Please, call #parse_file without autodetect and provide comment delimiters.") unless COMMENT_DELIMITERS.has_key?(ext)
      comment_delimiters = COMMENT_DELIMITERS[ext]
      comment_delimiter = comment_delimiters[0]
      start_multiline_comment_delimiter = comment_delimiters[1]
      end_multiline_comment_delimiter = comment_delimiters[2]
    end
    File.open(pathname) do |file|
      parse(file.read, comment_delimiter, start_multiline_comment_delimiter, end_multiline_comment_delimiter)
    end
  end
end
