# frozen_string_literal: true

require "json"

module Firepush
  class Message
    attr_reader :recipient    # @return [Firepush::Recipient::Base]
    attr_reader :message_type # @return [Firepush::MessageType::Base]

    # TODO: handle extra data in better way.
    attr_reader :extra # @return [Hash]

    # @param  msg [Hash]
    # @see lib/firepush/{message_type,recipient}/*.rb
    # @raise [ArgumentError]
    def initialize(msg)
      msg = msg.dup

      args = {}
      Recipient::TYPES.each do |type|
        args[type] = msg.delete(type) if msg.key?(type)
      end
      @recipient = Recipient::Builder.build(args)

      args.clear
      args[:notification] = msg.delete(:notification) if msg.key?(:notification)
      args[:data] = msg.delete(:data) if msg.key?(:data)
      @message_type = MessageType::Builder.build(args)

      @extra = msg
    end

    # @return [String]
    def to_json
      ::JSON.generate(message: message)
    end

    # @return [Boolean]
    def valid?
      recipient.valid? && message_type.valid?
    end

    private

    # @private
    # @return [Hash]
    def message
      {
        recipient.key    => recipient.value,
        message_type.key => message_type.value,
      }.merge(extra)
    end
  end
end
