# Parsed is the result of calling {FrontMatterParser.parse} or {FrontMatterParser.parse_file} in {FrontMatterParser}. It keeps the front matter and the content parsed and it has some useful methods to work with them.
class FrontMatterParser::Parsed
  # @!attribute [rw] front_matter
  #   @return [Hash{String => String, Array, Hash}] the parsed front matter
  # @!attribute [rw] content
  #   @return [String] the parsed content
  attr_accessor :front_matter, :content

  alias_method :to_hash, :front_matter

  # Returns the front matter value for the given key
  #
  # @param key [String] The key of the front matter
  # @return [String, Array, Hash] The value of the front matter for the given key
  def [](key)
    @front_matter[key]
  end
end
