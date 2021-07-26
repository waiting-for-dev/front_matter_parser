# frozen_string_literal: true

require 'yaml'

module FrontMatterParser
  module Loader
    # {Loader} that uses YAML library
    class Yaml
      # @!attribute [r] allowlist_classes
      # Classes that may be parsed by #call.
      attr_reader :allowlist_classes

      def initialize(allowlist_classes: [])
        @allowlist_classes = allowlist_classes
      end

      # Loads a hash front matter from a string
      #
      # @param string [String] front matter string representation
      # @return [Hash] front matter hash representation
      def call(string)
        if safe_load_with_permitted_classes_arg?
          YAML.safe_load(string, permitted_classes: allowlist_classes)
        else
          YAML.safe_load(string, allowlist_classes)
        end
      end

      def safe_load_with_permitted_classes_arg?
        # This `permitted_classes` keyword argument was
        # introduced in Ruby 2.6, and therefore is not
        # compatible with Ruby 2.5 and earlier.
        YAML
          .public_method(:safe_load).parameters
          .any? { |type, name| type == :key && name == :permitted_classes }
      end
    end
  end
end
