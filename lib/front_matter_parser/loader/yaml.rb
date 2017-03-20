# frozen_string_literal: true

require 'yaml'

module FrontMatterParser
  module Loader
    # {Loader} that uses YAML library
    class Yaml
      # Loads a hash front matter from a string
      #
      # @param string [String] front matter string representation
      # @return [Hash] front matter hash representation
      def self.call(string)
        YAML.safe_load(string)
      end
    end
  end
end
