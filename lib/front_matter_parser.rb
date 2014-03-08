require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

module FrontMatterParser
  def self.parse(string, comment_delimiter = '', start_multiline_comment_delimiter = '', end_multiline_comment_delimiter = '')
    parsed = Parsed.new
    if matches = (string.match(/
                               \A
                               (\n*)
                               (?-x:#{start_multiline_comment_delimiter})
                               (\n*)
                               (?-x:^#{comment_delimiter}[[:blank:]]*---$)
                               \n
                               (?<front_matter>.*)
                               (?-x:^#{comment_delimiter}[[:blank:]]*---$)
                               (\n*)
                               (?-x:#{end_multiline_comment_delimiter})
                               (\n*)
                               (?<content>.*)
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
