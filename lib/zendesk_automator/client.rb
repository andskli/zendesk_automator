module ZendeskAutomator
  class Client

    def initialize(url, username, token)
      $zendesk_client = ZendeskAPI::Client.new do |c|
        c.url = url
        c.username = username
        c.token = token
        c.logger = $logger
      end
    end

  end
end
