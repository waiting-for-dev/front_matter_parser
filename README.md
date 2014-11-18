# FrontMatterParser

FrontMatterParser is a library to parse files or strings with YAML front matters. It can automatically detect the syntax of a file from its extension and it supposes that the front matter is marked as that syntax comments.

## Installation

Add this line to your application's Gemfile:

    gem 'front_matter_parser'

or, to get the development version:

    gem 'front_matter_parser', github: 'waiting-for-dev/front_matter_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install front_matter_parser

## Usage

Front matters must be between two lines with three dashes `---`.

Given a file `example.md`:

```md
---
title: Hello World
category: Greetings
---
Some actual content
```

You can parse it:

```ruby
parsed = FrontMatterParser.parse_file('example.md')
parsed.front_matter #=> {'title' => 'Hello World', 'category' => 'Greetings'}
parsed.content #=> 'Some actual content'
```

You can apply directly `[]` method to get a front matter value:

```ruby
parsed['category'] #=> 'Greetings'
```

### Syntax autodetection

`FrontMatterParser` detects the syntax of a file by its extension and it supposes that the front matter is within that syntax comments delimiters.

Given a file `example.haml`:

```haml
-#
   ---
   title: Hello
   ---
Content
```

The `-#` and the indentation enclose the front matter as a comment. `FrontMatterParser` is aware of that, so you can simply do:

```ruby
title = FrontMatterParser.parse_file('example.haml')['title'] #=> 'Hello'
```

Following there is a relation of known syntaxes and their known comment delimiters:

<pre>
| Syntax | Single line comment | Start multiline comment | End multiline comment  |
| ------ | ------------------- | ----------------------- | ---------------------- |
| haml   |                     | -#                      | (indentation)          |
| slim   |                     | /                       | (indentation)          |
| liquid |                     | {% comment %}           | {% endcomment %}       |
| md     |                     |                         |                        |
| html   |                     | &lt;!--                    | --&gt;                    |
| erb    |                     | &lt;%#                     | %&gt;                     |
| coffee | #                   |                         |                        |
| sass   | //                  |                         |                        |
| scss   | //                  |                         |                        |
</pre>

For unknown syntaxes or alternative ones, you can provide your own single line comment delimiter with the `:comment` option, or multiline comment delimiters with `:start_comment` and `:end_comment`. If `:start_comment` is provided but it isn't `:end_comment`, then it is supposed that the multiline comment is ended by indentation.

```ruby
FrontMatterParser.parse_file('example.haml', start_comment: '<!--', end_comment: '-->') # start and end multiline comment delimiters
FrontMatterParser.parse_file('example.slim', start_comment: '/!') # multiline comment closed by indentation
FrontMatterParser.parse_file('example.foo', comment: '#') # single line comments
```

### Parsing a string

You can as well parse a string, providing manually the `syntax`:

```ruby
string = File.read('example.slim')
FrontMatterParser.parse(string, syntax: :slim)
```

or the comment delimiters:

```ruby
string = File.read('example.slim')
FrontMatterParser.parse(string, start_comment: '/!')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Release Policy

`front_matter_parser` follows the principles of [semantic versioning](http://semver.org/).

## To Do

* Add more known syntaxes.
* Allow configuration of global front matter delimiters. It would be easy, but I'm not sure if too useful.
* Allow different formats (as JSON). Again, I'm not sure if it would be very useful.

## Other ruby front matter parsers

* [front-matter](https://github.com/zhaocai/front-matter.rb) Can parse YAML front matters with single line comments delimiters. YAML must be correctly indented.
* [ruby_front_matter](https://github.com/F-3r/ruby_front_matter) Can parse JSON front matters and can configure front matter global delimiters, but does not accept comment delimiters.

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
