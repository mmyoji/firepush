# frozen_string_literal: true

module Firepush
  autoload :Client,       "firepush/client"
  autoload :Message,      "firepush/message"
  autoload :MessageTypes, "firepush/message_types"

  module MessageType
    autoload :Base,         "firepush/message_type/base"
    autoload :Builder,      "firepush/message_type/builder"
    autoload :Data,         "firepush/message_type/data"
    autoload :Notification, "firepush/message_type/notification"
  end

  module Recipient
    autoload :Base,      "firepush/recipient/base"
    autoload :Builder,   "firepush/recipient/builder"
    autoload :Condition, "firepush/recipient/condition"
    autoload :Token,     "firepush/recipient/token"
    autoload :Topic,     "firepush/recipient/topic"
  end

  autoload :HelperMethods, "firepush/helper_methods"
  autoload :Version,       "firepush/version"
end
