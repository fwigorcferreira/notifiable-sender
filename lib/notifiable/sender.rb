require "notifiable/sender/version"
require 'httparty'

module Notifiable
  module Sender
    class V1
      include HTTParty
      debug_output $stdout
      
      def initialize(base_uri, access_id)
        @base_uri, @access_id = base_uri, access_id
      end
      
      def send_notification_to_user(user_alias, message: nil)
        send_notification(message: message, filters: "[{\"property\": \"user_alias\", \"predicate\": \"eq\", \"value\": \"#{user_alias}\"}]")
      end
      
      def send_notification(message: nil, filters: nil, content_avaliable: nil)
        query = {}
        query[:message] = message if message
        query[:filters] = filters if filters
        query[:content_avaliable] = content_avaliable if content_avaliable
        self.class.post("#{@base_uri}/api/v1/notifications", 
          query: { notification: query },
          headers: {"Authorization" => @access_id}
        )
      end
      
    end
  end
end
