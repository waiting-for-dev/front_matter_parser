require "front_matter_parser/version"
require "front_matter_parser/parsed"

module FrontMatterParser
  def self.parse(string)
    parsed = Parsed.new
    parsed.front_matter = {}
    parsed.content = ''
    parsed
  end
end
