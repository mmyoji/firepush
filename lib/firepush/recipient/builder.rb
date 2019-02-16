# frozen_string_literal: true

module Firepush
  module Recipient
    class Builder
      # @param  args [Hash]
      # @option args [Hash] :topic
      # @option args [Hash] :token
      def self.build(args)
        new(args).build
      end

      # @private
      # @see .build
      def initialize(args)
        @_args = args

        check_args!
      end
      private_class_method :new

      # @return [Firepush::Recipient::Base]
      def build
        case
        when topic?
          Topic.new(_args.fetch(:topic))
        when token?
          Token.new(_args.fetch(:token))
        end
      end

      private

      attr_reader :_args

      # @private
      # @raise [ArgumentError]
      def check_args!
        if topic? && token?
          raise ::ArgumentError.new("Cannot set both :topic and :token")
        end

        if !topic? && !token?
          raise ::ArgumentError.new("Must set either :topic or :token")
        end
      end

      # @private
      # @return [Boolean]
      def token?
        _args.key?(:token)
      end

      # @private
      # @return [Boolean]
      def topic?
        _args.key?(:topic)
      end
    end
  end
end
