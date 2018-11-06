# frozen_string_literal: true

require 'spec_helper'
require 'front_matter_parser/dumper'

describe FrontMatterParser::Dumper::Yaml do
  describe '#call' do
    it 'loads using yaml parser' do
      hash = { 'title' => 'hello' }

      expect(described_class.new.call(hash)).to eq("---\ntitle: hello")
    end
  end
end
