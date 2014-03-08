require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

module FrontMatterParser
  def self.parse(string, comment_delimiter = nil, start_multiline_comment_delimiter = nil, end_multiline_comment_delimiter = nil)
    parsed = Parsed.new
    if matches = (string.match(/
                               # Start of string
                               \A
                               # Zero or more space characters
                               ([[:space:]]*)
                               # Start multiline comment
                               #{'(?-x:^[[:blank:]]*'+start_multiline_comment_delimiter+'[[:blank:]]*[\n\r][[:space:]]*)' unless start_multiline_comment_delimiter.nil?}
                               # Begin front matter
                               (?-x:^[[:blank:]]*#{comment_delimiter}[[:blank:]]*---[[:blank:]]*$[\n\r])
                               # The front matter
                               (?<front_matter>.*)
                               # End front matter
                               (?-x:^[[:blank:]]*#{comment_delimiter}[[:blank:]]*---[[:blank:]]*$[\n\r])
                               # End multiline comment
                                 #{'(?-x:[[:space:]]*^[[:blank:]]*'+end_multiline_comment_delimiter+'[[:blank:]]*[\n\r])' unless end_multiline_comment_delimiter.nil?}
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
end
