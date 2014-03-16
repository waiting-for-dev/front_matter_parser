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
  end
end
