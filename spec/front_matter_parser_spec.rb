require 'spec_helper'

describe FrontMatterParser do
  let(:sample_fm) { {'title' => 'hello'} }
  let(:sample_c) { 'Content' }

  it 'has a version number' do
    expect(FrontMatterParser::VERSION).to_not be_nil
  end

  describe "#parse" do
    context "when the string has both front matter and content" do
      let(:parsed) { FrontMatterParser.parse(string) }

      it "parses the front matter as a hash" do
        expect(parsed.front_matter).to eq(sample_fm)
      end

      it "parses the content as a string" do
        expect(parsed.content).to eq(sample_c)
      end
    end

    context "when the string only has front matter" do
      let(:parsed) { FrontMatterParser.parse(string_no_content) }

      it "parses the front matter as a hash" do
        expect(parsed.front_matter).to eq(sample_fm)
      end

      it "parses the content as an empty string" do
        expect(parsed.content).to eq('')
      end
    end

    context "when an empty front matter is supplied" do
      let(:parsed) { FrontMatterParser.parse(string_no_front_matter) }

      it "parses the front matter as an empty hash" do
        expect(parsed.front_matter).to eq({})
      end

      it "parses the content as the whole string" do
        expect(parsed.content).to eq(sample_c)
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

    context "when :comment option is given" do
      it "takes it as the single line comment mark for the front matter" do
        parsed = FrontMatterParser.parse(string_comment('#'), comment: '#')
        expect(parsed.front_matter).to eq(sample_fm)
      end

      context "when :start_comment is given" do
        it "raises an ArgumentError" do
          expect { FrontMatterParser.parse(string_comment('#'), comment: '#', start_comment: '/')}.to raise_error ArgumentError
        end
      end
    end

    context "when :start_comment option is given" do
      context "when :end_comment option is not given" do
        it "takes :start_comment as the mark for a multiline comment closed by indentation for the front matter" do
          parsed = FrontMatterParser.parse(string_start_comment('/'), start_comment: '/')
          expect(parsed.front_matter).to eq(sample_fm)
        end
      end

      context "when :end_comment option is provided" do
        it "takes :start_comment and :end_comment as the multiline comment mark delimiters for the front matter" do
          parsed = FrontMatterParser.parse(string_start_end_comment('<!--', '-->'), start_comment: '<!--', end_coment: '-->')
          expect(parsed.front_matter).to eq(sample_fm)
        end
      end
    end

    context "when :end_comment option is given but :start_comment is not" do
      it "raises an ArgumentError" do
        expect {FrontMatterParser.parse(string_start_end_comment, end_comment: '-->')}.to raise_error(ArgumentError)
      end
    end

    context "when :syntax is given" do
      context "when :comment and :start_comment are not given" do
        syntaxs.each_pair do |name, value|
          it "can detect a #{name} syntax when its value is #{value}" do
            parsed = FrontMatterParser.parse(File.read(File.expand_path("../fixtures/example.#{value}", __FILE__)), syntax: value)
            expect(parsed.front_matter).to eq(sample_fm)
          end
        end

        it "raises an ArgumentError if syntax is not whithin COMMENT_DELIMITERS keys" do
          expect { FrontMatterParser.parse(string, syntax: :foo) }.to raise_error ArgumentError
        end
      end

      context "when :comment is given" do
        it ":syntax is ignored" do
          parsed = FrontMatterParser.parse(File.read(File.expand_path("../fixtures/example.coffee", __FILE__)), syntax: :slim, comment: '#' )
          expect(parsed.front_matter).to eq(sample_fm)
        end
      end

      context "when :start_comment is given" do
        it ":syntax is ignored" do
          parsed = FrontMatterParser.parse(File.read(File.expand_path("../fixtures/example.slim", __FILE__)), syntax: :coffee, start_comment: '/' )
          expect(parsed.front_matter).to eq(sample_fm)
        end
      end
    end
  end

  describe "#parse_file" do
    context "when the file has both front matter and content" do
      let(:parsed) { FrontMatterParser.parse_file(file_fixture(string), comment: '') }

      it "parses the front matter as a hash" do
        expect(parsed.front_matter).to eq(sample_fm)
      end

      it "parses the content as a string" do
        expect(parsed.content).to eq(sample_c)
      end
    end

    context "when the file only has front matter" do
      let(:parsed) { FrontMatterParser.parse_file(file_fixture(string_no_content), comment: '') }

      it "parses the front matter as a hash" do
        expect(parsed.front_matter).to eq(sample_fm)
      end

      it "parses the content as an empty string" do
        expect(parsed.content).to eq('')
      end
    end

    context "when the file has an empty front matter is supplied" do
      let(:parsed) { FrontMatterParser.parse_file(file_fixture(string_no_front_matter), comment: '') }

      it "parses the front matter as an empty hash" do
        expect(parsed.front_matter).to eq({})
      end

      it "parses the content as the whole string" do
        expect(parsed.content).to eq(sample_c)
      end
    end

    context "when the file has no content" do
      let(:parsed) { FrontMatterParser.parse_file(file_fixture(''), comment: '') }

      it "parses the front matter as an empty hash" do
        expect(parsed.front_matter).to eq({})
      end

      it  "parses the content as an empty string" do
        expect(parsed.content).to eq('')
      end
    end

    context "when :comment option is given" do
      it "takes it as the single line comment mark for the front matter" do
        parsed = FrontMatterParser.parse_file(file_fixture(string_comment('#')), comment: '#')
        expect(parsed.front_matter).to eq(sample_fm)
      end

      context "when :start_comment is given" do
        it "raises an ArgumentError" do
          expect { FrontMatterParser.parse_file(file_fixture(string_comment('#')), comment: '#', start_comment: '/')}.to raise_error ArgumentError
        end
      end
    end

    context "when :start_comment option is given" do
      context "when :end_comment option is not given" do
        it "takes :start_comment as the mark for a multiline comment closed by indentation for the front matter" do
          parsed = FrontMatterParser.parse_file(file_fixture(string_start_comment('/')), start_comment: '/')
          expect(parsed.front_matter).to eq(sample_fm)
        end
      end

      context "when :end_comment option is provided" do
        it "takes :start_comment and :end_comment as the multiline comment mark delimiters for the front matter" do
          parsed = FrontMatterParser.parse_file(file_fixture(string_start_end_comment('<!--', '-->')), start_comment: '<!--', end_coment: '-->')
          expect(parsed.front_matter).to eq(sample_fm)
        end
      end
    end

    context "when :end_comment option is given but :start_comment is not" do
      it "raises an ArgumentError" do
        expect {FrontMatterParser.parse_file(file_fixture(string_start_end_comment), end_comment: '-->')}.to raise_error(ArgumentError)
      end
    end

    context "when :comment and :start_comment are not given" do
      syntaxs.each_pair do |name, value|
        it "can detect a #{name} syntax file when its extension is #{value}" do
          parsed = FrontMatterParser.parse_file(File.expand_path("../fixtures/example.#{value}", __FILE__))
          expect(parsed.front_matter).to eq(sample_fm)
        end
      end

      it "raises an ArgumentError if the file extension is not whithin COMMENT_DELIMITERS keys" do
        expect { FrontMatterParser.parse_file(File.expand_path("../fixtures/example.foo, __FILE__")) }.to raise_error RuntimeError
      end

      it "raises an ArgumentError if the file has no extension" do
        expect { FrontMatterParser.parse_file(File.expand_path("../fixtures/example, __FILE__")) }.to raise_error RuntimeError
      end
    end
  end
end

describe "the front matter" do
  let(:sample_fm) { {'title' => 'hello'} }

  it "can be indented" do
    string = %Q(
  ---
  title: hello
  ---
Content)
    expect(FrontMatterParser.parse(string).front_matter).to eq(sample_fm)
  end

  it "can have each line commented" do
    string = %Q(
#---
#title: hello
#---
Content)
    expect(FrontMatterParser.parse(string, comment: '#').front_matter).to eq(sample_fm)
  end

  it "can be indented after the comment delimiter" do
    string = %Q(
#  ---
#  title: hello
#  ---
Content)
    expect(FrontMatterParser.parse(string, comment: '#').front_matter).to eq(sample_fm)
  end

  it "can be between a multiline comment" do
    string = %Q(
<!--
---
title: hello
---
-->
Content)
    expect(FrontMatterParser.parse(string, start_comment: '<!--', end_comment: '-->').front_matter).to eq(sample_fm)
  end

  it "can have the multiline comment delimiters indented" do
    string = %Q(
    <!--
    ---
    title: hello
    ---
    -->
Content)
    expect(FrontMatterParser.parse(string, start_comment: '<!--', end_comment: '-->').front_matter).to eq(sample_fm)
  end

  it "can have empty lines between the multiline comment delimiters and the front matter" do
    string = %Q(
<!--

---
title: hello
---

-->
Content)
    expect(FrontMatterParser.parse(string, start_comment: '<!--', end_comment: '-->').front_matter).to eq(sample_fm)
  end

  it "can have multiline comment delimited by indentation" do
    string = %Q(
  /
    ---
    title: hello
    ---
  Content)
    expect(FrontMatterParser.parse(string, start_comment: '/').front_matter).to eq(sample_fm)
  end
end
