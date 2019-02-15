# frozen_string_literal: true

module Firepush
  module MessageType
    class Data < Base
      attr_reader :data # @return [Hash<Symbol, String>]

      # @param args [Hash]
      def initialize(args)
        @data = args
      end

      # @override
      # @return [Boolean]
      def valid?
        data.is_a?(::Hash) && data.values.all? { |v| v.is_a?(::String) }
      end

      # @override
      # @return [Hash]
      def value
        data
      end
    end
  end
end
