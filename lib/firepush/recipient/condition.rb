# frozen_string_literal: true

module Firepush
  module Recipient
    class Condition < Base
      attr_reader :condition # @return [String]

      # @param condition [String]
      def initialize(condition)
        @condition = condition
      end

      # @override
      # @return [Boolean]
      # @see https://firebase.google.com/docs/cloud-messaging/send-message?hl=en
      # @note Doesn't add parser for the condition string because it can be mess
      def valid?
        valid_str?(condition)
      end

      # @override
      # @return [String]
      def value
        condition
      end
    end
  end
end
