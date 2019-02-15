# frozen_string_literal: true

module Firepush
  module Recipient
    class Topic < Base
      attr_reader :topic # @return [String]

      # @param topic [String]
      def initialize(topic)
        @topic = topic
      end

      # @override
      # @return [Boolean]
      def valid?
        valid_str?(topic)
      end

      # @override
      # @return [String]
      def value
        topic
      end
    end
  end
end
