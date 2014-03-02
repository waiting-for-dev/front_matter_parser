require 'yaml'
require "front_matter_parser/version"
require "front_matter_parser/parsed"

module FrontMatterParser
  def self.parse(string)
    parsed = Parsed.new
    if matches = (string.match(/\A(\n*)(---)\n(?<front_matter>.*)(---\n)(?<content>.*)\z/m))
      parsed.front_matter = YAML.load(matches[:front_matter])
      parsed.content = matches[:content]
    else
      parsed.front_matter = {}
      parsed.content = string
    end
    parsed
  end
end
