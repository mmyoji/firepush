# frozen_string_literal: true

module Firepush
  module MessageType
    class Notification < Base
      attr_reader :title # @return [String]
      attr_reader :body  # @return [String]

      # @param :title [String]
      # @param :body  [String]
      def initialize(title:, body:)
        @title = title
        @body  = body
      end

      # @override
      # @return [Boolean]
      def valid?
        valid_str?(title) && valid_str?(body)
      end

      # @override
      # @return [Hash]
      def value
        { title: title, body: body }
      end
    end
  end
end
