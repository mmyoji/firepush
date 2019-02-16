# frozen_string_literal: true

require "net/http"

module Firepush
  class Client
    class InvalidAttributes < ::StandardError; end

    include HelperMethods

    BASE_URI  = "https://fcm.googleapis.com"
    BASE_PATH = "/v1/projects"

    attr_accessor :access_token # @return [String]
    attr_accessor :project_id   # @return [String]

    attr_reader :message # @return [String]

    # @param :access_token [String] optional
    # @param :project_id   [String] optional
    def initialize(access_token: "", project_id: "")
      self.access_token = access_token
      self.project_id   = project_id
    end

    # @param message [Hash]
    def message=(message)
      @message = Message.new(message)
    end

    # @param message [Hash] optional
    #
    # TODO: Return useful response
    # @return [Http::Response]
    #
    # @raise [Firepush::Client::InvalidAttributes]
    def push(message = nil)
      self.message = message unless message.nil?

      raise InvalidAttributes unless valid?

      http.post(path, message.to_json, headers)
    end

    # @return [Boolean]
    def valid?
      valid_str?(access_token) && valid_str?(project_id) &&
        !message.nil? && message.valid?
    end

    private

    # @private
    # @return [Hash]
    def headers
      {
        "Content-Type"  => "application/json",
        "Authorization" => "Bearer #{access_token}",
      }
    end

    # @private
    # @return [Net::HTTP]
    def http
      @http ||=
        begin
          h = ::Net::HTTP.new(uri.host, uri.port)
          h.use_ssl = true
          h
        end
    end

    # @private
    # @return [String]
    def path
      "/#{project_id}/messages:send"
    end

    # @private
    # @return [URI::HTTPS]
    def uri
      @uri ||= ::URI.parse(BASE_URI)
    end
  end
end
