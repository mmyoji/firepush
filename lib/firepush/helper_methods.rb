# frozen_string_literal: true

module Firepush
  module HelperMethods
    private

    # @private
    # @param val [String]
    # @return [Boolean]
    def valid_str?(val)
      val.is_a?(::String) && val != ""
    end
  end
end
