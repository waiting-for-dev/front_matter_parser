class FrontMatterParser::Parsed
  attr_accessor :front_matter, :content

  def to_hash
    @front_matter
  end

  def [](key)
    @front_matter[key]
  end
end
