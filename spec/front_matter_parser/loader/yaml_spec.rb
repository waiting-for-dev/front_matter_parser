# frozen_string_literal: true

require 'spec_helper'

describe FrontMatterParser::Loader::Yaml do
  describe '::call' do
    it 'loads using yaml parser' do
      string = "title: 'hello'"

      expect(described_class.call(string)).to eq(
        'title' => 'hello'
      )
    end
  end
end
