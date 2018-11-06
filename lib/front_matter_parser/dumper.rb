# frozen_string_literal: true

require 'front_matter_parser/dumper/yaml'

module FrontMatterParser
  # This module includes front matter dumpers (to a string from hash).
  # They must respond to a `::call` method which accepts the Hash as argument
  # and respond with a String.
  module Dumper
  end
end
