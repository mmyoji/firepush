# frozen_string_literal: true

require "json"

module Firepush
  class Message
    attr_reader :recipient     # @return [Firepush::Recipient::Base]
    attr_reader :message_types # @return [Firepush::MessageTypes]

    # TODO: handle extra data in better way.
    attr_reader :extra # @return [Hash]

    # @param  msg [Hash]
    # @see lib/firepush/{recipient/*,message_types}.rb
    # @raise [ArgumentError]
    def initialize(msg)
      msg = msg.dup

      args = {}
      Recipient::TYPES.each do |type|
        args[type] = msg.delete(type) if msg.key?(type)
      end
      @recipient = Recipient::Builder.build(args)

      args.clear
      MessageType::TYPES.each do |type|
        args[type] = msg.delete(type) if msg.key?(type)
      end
      @message_types = MessageTypes.new(args)

      @extra = msg
    end

    # @return [String]
    def to_json
      ::JSON.generate(message: message)
    end

    # @return [Boolean]
    def valid?
      recipient.valid? && message_types.valid?
    end

    private

    # @private
    # @return [Hash]
    def message
      message_types.message.merge({
        recipient.key => recipient.value
      }.merge(extra))
    end
  end
end
