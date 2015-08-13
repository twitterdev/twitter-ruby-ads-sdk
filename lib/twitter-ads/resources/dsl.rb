# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  # A light-wight DSL for building out Twitter Ads API resources.
  module DSL

    def self.included(klass)
      klass.send :include, InstanceMethods
      klass.extend ClassMethods
    end

    module InstanceMethods

      # Populates a given objects attributes from a parsed JSON API response. This helper
      # handles all necessary type coercions as it assigns attribute values.
      #
      # @param object [Hash] The parsed JSON response object.
      #
      # @return [self] A fully hydrated instance of the current class.
      #
      # @since 0.1.0
      def from_response(object)
        self.class.properties.each do |name, type|
          value = if type == :time && object[name] && !object[name].empty?
            Time.parse(object[name])
          elsif type == :bool && object[name]
            Utils.to_bool(object[name])
          end
          instance_variable_set("@#{name}", value || object[name])
        end
        self
      end

      # Generates a Hash of property values for the current object. This helper
      # handles all necessary type coercions as it generates its output.
      #
      # @return [Hash] A Hash of the object's properties and cooresponding values.
      #
      # @since 0.1.0
      def to_params
        params = {}
        self.class.properties.each do |name, type|
          value = send(name)
          next unless value
          params[name] = if type == :time
            value.iso8601
          elsif type == :bool
            !!value
          elsif value.is_a?(Array)
            value.join(',')
          else
            value
          end
        end
        params
      end

    end

    module ClassMethods

      # Resource property declaration helper.
      #
      # @example
      #   class Foo
      #     include TwitterAds::DSL
      #
      #     property :foo
      #     property :bar, type: :bool
      #     property :created_at, type: time, read_only: true
      #   end
      #
      # @param name [Symbol] The name of the property.
      # @param opts [Hash] A Hash of extended options to be applied to the property (Optional).
      #
      # @return [Symbol] The property name.
      #
      # @since 0.1.0
      def property(name, opts = {})
        properties[name] = opts.fetch(:type, nil)
        opts[:read_only] ? attr_reader(name) : attr_accessor(name)
        name
      end

      # Helper for managing properties for the current class.
      #
      # @return [Hash] A Hash of properties declared in the current class.
      #
      # @api private
      # @since 0.1.0
      def properties
        @properties ||= {}
      end

    end

  end
end
