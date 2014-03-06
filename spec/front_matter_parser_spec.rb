require 'spec_helper'

describe FrontMatterParser do
  it 'has a version number' do
    expect(FrontMatterParser::VERSION).to_not be_nil
  end

  describe "#parse" do
    context "when the string has both front matter and content" do
      let(:string) { %Q(
---
title: hello
---
Content
) }
      let(:parsed) { FrontMatterParser.parse(string) }

      it "parsed the front matter as a hash" do
        expect(parsed.front_matter).to eq({'title' => 'hello'})
      end

      it "parses the content as a string" do
        expect(parsed.content).to eq("Content\n")
      end
    end

    context "when the string only has front matter" do
      let(:string) { %Q(
---
title: hello
---
) }
      let(:parsed) { FrontMatterParser.parse(string) }

      it "parses the front matter as a hash" do
        expect(parsed.front_matter).to eq({'title' => 'hello'})
      end

      it "parsed the content as an empty string" do
        expect(parsed.content).to eq('')
      end
    end

    context "when an empty front matter is supplied" do
      let(:string) { %Q(Hello) }
      let(:parsed) { FrontMatterParser.parse(string) }

      it "parses the front matter as an empty hash" do
        expect(parsed.front_matter).to eq({})
      end

      it "parses the content as the whole string" do
        expect(parsed.content).to eq(string)
      end
    end

    context "when an empty string is supplied" do
      let(:parsed) { FrontMatterParser.parse('') }

      it "parses the front matter as an empty hash" do
        expect(parsed.front_matter).to eq({})
      end

      it  "parses the content as an empty string" do
        expect(parsed.content).to eq('')
      end
    end
  end
end

describe "the front matter" do
  it "can have each line commented" do
    string = %Q(
#---
#title: hello
#---
Content
)
    expect(FrontMatterParser.parse(string, '#').front_matter).to eq({'title' => 'hello'})
  end

  it "can have each line commented with extra spaces between the comment delimiter and the front matter line" do
    string = %Q(
#  ---
#  title: hello
#  ---
Content
)
    expect(FrontMatterParser.parse(string, '#').front_matter).to eq({'title' => 'hello'})
  end

  it "can be between a multiline comment" do
    string = %Q(
<!--
---
title: hello
---
-->
Content
)
    expect(FrontMatterParser.parse(string, '', '<!--', '-->').front_matter).to eq({'title' => 'hello'})
  end
end
