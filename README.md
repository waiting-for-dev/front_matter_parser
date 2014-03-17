# FrontMatterParser

FrontMatterParser is a library to parse strings or files with YAML front matters. When working with files, it can automatically detect the syntax of a file from its extension and it supposes that the front matter is marked as that syntax comments.

## Installation

Add this line to your application's Gemfile:

    gem 'front_matter_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install front_matter_parser

## Usage

Front matters must be between two lines with three dashes `---`.

Given a file `example.md`:

    ---
    title: Hello World
    category: Greetings
    ---
    Some actual content

You can parse it:

    parsed = FrontMatterParser.parse_file('example.md')
    parsed.front_matter #=> {'title' => 'Hello World'}
    parsed.content #=> 'Some actual content'

You can apply directly `[]` method to get a front matter value:

    parsed['category'] #=> 'Greetings'

### Syntax autodetection

`FrontMatterParser` detects the syntax of a file by its extension and suppose that the front matter is within that syntax comments delimiters.

Given a file `example.haml`:

    -#
       ---
       title: Hello
       ---
    Content

The `-#` and the indentation enclose the front matter as a comment. `FrontMatterParser` is aware of it and you can simply do:

    title = FrontMatterParser.parse_file('example.haml')['title']

Following there is a relation of known syntaxs and their known comment delimiters:

<pre>
| Syntax | Single line comment | Start multiline comment | End multiline comment  |
| ------ | ------------------- | ----------------------- | ---------------------- |
| haml   |                     | -#                      | (indentation)          |
| slim   |                     | /                       | (indentation)          |
| liquid |                     | <% comment %>           | <% endcomment %>       |
| md     |                     |                         |                        |
| html   |                     | &lt;!--                 | --&gt;                 |
| coffee | #                   |                         |                        |
| sass   | //                  |                         |                        |
| scss   | //                  |                         |                        |
</pre>

You can overide them passing `false` as second argument for `parse_file` and then the delimiters for single line comment, start multiline comment and end multilien comment:

    FrontMatterParser.parse_file('example.haml', false, nil, '<!--', '-->')

### Parsing a string

You can as well parse a string, providing manually its comment delimiters if needed:

    string = File.read('example.html')
    FrontMatterParser.parse(string, nil, '<!--', '-->')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Release Policy

`front_matter_parser` follows the principles of [semantic versioning](http://semver.org/).

## LICENSE

Copyright 2013 Marc Busqué - <marc@lamarciana.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
