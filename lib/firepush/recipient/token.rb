# frozen_string_literal: true

module Firepush
  module Recipient
    class Token < Base
      attr_reader :token # @return [String]

      # @param token [String] Android Registration ID
      def initialize(token)
        @token = token
      end

      # @override
      # @return [Boolean]
      def valid?
        valid_str?(token)
      end

      # @override
      # @return [String]
      def value
        token
      end
    end
  end
end
