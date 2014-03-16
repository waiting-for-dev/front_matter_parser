require 'spec_helper'

module FrontMatterParser
  describe Parsed do

    let(:sample) { {'title' => 'hello'} }

    let(:string) { %Q(
---
title: hello
---
Content) }

    let(:parsed) { FrontMatterParser.parse(string) }

    describe "#to_hash" do
      it "returns @front_matter" do
        expect(parsed.to_hash).to eq(sample)
      end
    end

    describe "#[]" do
      it "returns the front matter value for the given key" do
        expect(parsed['title']).to eq('hello')
      end
    end
  end
end
