# frozen_string_literal: true

require 'spec_helper'

describe FrontMatterParser::Parsed do
  let(:front_matter) { { 'title' => 'hello' } }
  let(:content) { 'Content' }

  subject(:parsed) do
    described_class.new(front_matter: front_matter, content: content)
  end

  describe '#[]' do
    it 'returns front_matter value for given key' do
      expect(parsed['title']).to eq('hello')
    end
  end
end
