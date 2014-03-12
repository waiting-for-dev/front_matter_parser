require 'spec_helper'

describe FrontMatterParser do
  let(:sample) { {'title' => 'hello'} }

  it 'has a version number' do
    expect(FrontMatterParser::VERSION).to_not be_nil
  end

  describe "#parse" do
    context "when the string has both front matter and content" do
      let(:string) { %Q(
---
title: hello
---
Content) }
      let(:parsed) { FrontMatterParser.parse(string) }

      it "parses the front matter as a hash" do
        expect(parsed.front_matter).to eq(sample)
      end

      it "parses the content as a string" do
        expect(parsed.content).to eq("Content")
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
        expect(parsed.front_matter).to eq(sample)
      end

      it "parses the content as an empty string" do
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

    context "when only one of the pair of multiline comment delimiters are supplied" do
      it "raises an ArgumentError" do
        string = %Q(
<!--
---
title: hello
---
-->
Content)
        expect {FrontMatterParser.parse(string, nil, '<!--', nil)}.to raise_error(ArgumentError)
        expect {FrontMatterParser.parse(string, nil, nil, '-->')}.to raise_error(ArgumentError)
      end
    end
  end

  describe "#parse_file" do
    context "when autodetect is true" do
      it "can detect a slim file" do
        expect(FrontMatterParser).to receive(:parse).with(File.read(File.expand_path('../example_files/example.slim', __FILE__)), '/', nil, nil)
        FrontMatterParser.parse_file(File.expand_path('../example_files/example.slim', __FILE__), true)
      end

      context "when the file extension is unknown" do
        it "raises a RuntimeError" do
          expect {FrontMatterParser.parse_file(File.expand_path('../example_files/example.foo', __FILE__), true)}.to raise_error(RuntimeError)
        end
      end
    end

    context "when autodetect is false" do
      it "calls #parse with the content of the file and given comment delimiters" do
        expect(FrontMatterParser).to receive(:parse).with(File.read(File.expand_path('../example_files/example.md', __FILE__)), nil, nil, nil)
        FrontMatterParser.parse_file(File.expand_path('../example_files/example.md', __FILE__), false)
      end
    end
  end
end

describe "the front matter" do
  let(:sample) { {'title' => 'hello'} }

  it "can be indented" do
    string = %Q(
  ---
  title: hello
  ---
Content)
    expect(FrontMatterParser.parse(string).front_matter).to eq(sample)
  end

  it "can have each line commented" do
    string = %Q(
#---
#title: hello
#---
Content)
    expect(FrontMatterParser.parse(string, '#').front_matter).to eq(sample)
  end

  it "can be indented after the comment delimiter" do
    string = %Q(
#  ---
#  title: hello
#  ---
Content)
    expect(FrontMatterParser.parse(string, '#').front_matter).to eq(sample)
  end

  it "can be between a multiline comment" do
    string = %Q(
<!--
---
title: hello
---
-->
Content)
    expect(FrontMatterParser.parse(string, nil, '<!--', '-->').front_matter).to eq(sample)
  end

  it "can have the multiline comment delimiters indented" do
    string = %Q(
    <!--
    ---
    title: hello
    ---
    -->
Content)
    expect(FrontMatterParser.parse(string, nil, '<!--', '-->').front_matter).to eq(sample)
  end

  it "can have empty lines between the multiline comment delimiters and the front matter" do
    string = %Q(
<!--

---
title: hello
---
  
-->
Content)
    expect(FrontMatterParser.parse(string, nil, '<!--', '-->').front_matter).to eq(sample)
  end
end
