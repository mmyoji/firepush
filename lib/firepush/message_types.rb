# frozen_string_literal: true

module Firepush
  class MessageTypes
    attr_reader :types # @return [Array<Firepush::MessageType::Base>]

    # @param  args [Hash]
    # @option args [Hash] :notification
    # @option args [Hash] :data
    def initialize(args)
      valid_types = MessageType::TYPES.reduce([]) do |acc, type|
        acc.push(type => args[type]) if args.key?(type)
        acc
      end

      @types = valid_types.map { |type| MessageType::Builder.build(type) }
    end

    # @return [Hash]
    def message
      types.reduce({}) do |acc, type|
        acc[type.key] = type.value
        acc
      end
    end

    # @return [Boolean]
    def valid?
      types.count > 0 && types.all?(&:valid?)
    end
  end
end
