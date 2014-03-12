require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

module FrontMatterParser
  COMMENT_DELIMITERS = {
    slim: [nil, '/', nil],
    html: [nil, '<!--', '-->'],
    coffee: ['#', nil, nil],
  }

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
