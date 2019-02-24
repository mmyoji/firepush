# frozen_string_literal: true

module Firepush
  module Recipient
    TYPES = %i(topic token condition)

    class Builder
      # @param  args [Hash]
      # @option args [Hash] :topic
      # @option args [Hash] :token
      # @option args [Hash] :condition
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
        when condition?
          Condition.new(_args.fetch(:condition))
        end
      end

      private

      attr_reader :_args

      # @private
      # @raise [ArgumentError]
      def check_args!
        count = TYPES.reduce(0) do |sum, type|
          sum += 1 if _args.key?(type)
          sum
        end
        return if count == 1

        raise ::ArgumentError.new("Have to set one of :topic, :token, or :condition")
      end

      # @private
      # @return [Boolean]
      def condition?
        _args.key?(:condition)
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
