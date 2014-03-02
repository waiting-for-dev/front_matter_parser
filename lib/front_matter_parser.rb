require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

module FrontMatterParser
  def self.parse(string, comment_delimiter = '', start_multiline_comment_delimiter = '', end_multiline_comment_delimiter = '')
    parsed = Parsed.new
    if matches = (string.match(/\A(\n*)(#{start_multiline_comment_delimiter})(\n*)(#{comment_delimiter}---)\n(?<front_matter>.*)(#{comment_delimiter}---)(\n*)(#{end_multiline_comment_delimiter})(\n*)(?<content>.*)\z/m))
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
