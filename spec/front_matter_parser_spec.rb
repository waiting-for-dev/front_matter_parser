require 'spec_helper'

describe FrontMatterParser do
  it 'has a version number' do
    expect(FrontMatterParser::VERSION).to_not be_nil
  end

  describe "#parse" do
    context "when an empty string is supplied" do
      let(:parsed) { FrontMatterParser.parse('') }

      it "returns a Parsed instance with an empty hash as front_matter" do
        expect(parsed.front_matter).to eq({})
      end

      it "returns a Parsed instance with an empty string as content" do
        expect(parsed.content).to eq('')
      end
    end
  end
end
