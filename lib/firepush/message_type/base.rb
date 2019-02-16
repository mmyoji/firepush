# frozen_string_literal: true

module Firepush
  module MessageType
    # @abstract
    class Base
      include HelperMethods

      # @return [Symbol]
      def key
        self.class.name.split("::").last.downcase.intern
      end

      # @return [Boolean]
      def valid?
        raise "#{__method__} is not implemented!"
      end

      # @return [Hash]
      def value
        raise "#{__method__} is not implemented!"
      end
    end
  end
end
