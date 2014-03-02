require 'spec_helper'

describe FrontMatterParser do
  it 'has a version number' do
    expect(FrontMatterParser::VERSION).to_not be_nil
  end

  describe "#parse" do
    context "when an empty string is supplied" do
      let(:parsed) { FrontMatterParser.parse('') }

      it "the parsed front matter is an empty hash" do
        expect(parsed.front_matter).to eq({})
      end

      it "the parsed content is an empty string" do
        expect(parsed.content).to eq('')
      end
    end

    context "when an empty front matter is supplied" do
      let(:string) { %Q(Hello) }
      let(:parsed) { FrontMatterParser.parse(string) }

      it "the parsed front matter is an empty hash" do
        expect(parsed.front_matter).to eq({})
      end

      it "the parsed content is the whole string" do
        expect(parsed.content).to eq(string)
      end
    end

    context "when the string only has front matter" do
      let(:string) { %Q(
---
title: hello
---
) }
      let(:parsed) { FrontMatterParser.parse(string) }

      it "the front matter is parsed" do
        expect(parsed.front_matter).to eq({'title' => 'hello'})
      end

      it "the content is an empty string" do
        expect(parsed.content).to eq('')
      end
    end

    context "when the string has both front matter and content" do
      let(:string) { %Q(
---
title: hello
---
Content
) }
      let(:parsed) { FrontMatterParser.parse(string) }

      it "the front matter is parsed" do
        expect(parsed.front_matter).to eq({'title' => 'hello'})
      end

      it "the content is parsed" do
        expect(parsed.content).to eq("Content\n")
      end
    end

    context "when front matter is commented" do
      let(:string) { %Q(
#---
#title: hello
#---
Content
) }

      let(:parsed) { FrontMatterParser.parse(string, '#') }

      it "strips the comments and parse the front matter" do
        expect(parsed.front_matter).to eq({'title' => 'hello'})
      end

      it "parses the content" do
        expect(parsed.content).to eq("Content\n")
      end
    end
  end
end
