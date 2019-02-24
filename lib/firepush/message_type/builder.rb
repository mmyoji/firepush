# frozen_string_literal: true

module Firepush
  module MessageType
    # TODO: support :android, :webpush and :apns
    TYPES = %i(notification data)

    class Builder
      # @param  args [Hash]
      # @option args [Hash] :notification
      # @option args [Hash] :data
      def self.build(args)
        new(args).build
      end

      # @private
      # @see .build
      def initialize(args)
        @_args = args
      end
      private_class_method :new

      # @return [Firepush::MessageType::Base]
      def build
        case
        when notification?
          Notification.new(_args.fetch(:notification))
        when data?
          Data.new(_args.fetch(:data))
        end
      end

      private

      attr_reader :_args

      # @private
      # @return [Boolean]
      def data?
        _args.key?(:data)
      end

      # @private
      # @return [Boolean]
      def notification?
        _args.key?(:notification)
      end
    end
  end
end
