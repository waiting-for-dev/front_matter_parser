# frozen_string_literal: true

require 'yaml'

module FrontMatterParser
  module Dumper
    # {Loader} that uses YAML library
    class Yaml
      # Dumps a string front matter from a hash
      #
      # @param hash [Hash] front matter hash representation
      # @return [String] front matter string representation
      def call(hash)
        YAML.dump(hash).chomp
      end
    end
  end
end
