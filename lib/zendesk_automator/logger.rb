require 'logger'

$stderr.sync = true
$logger = Logger.new($stderr)
$logger.level = Logger::DEBUG

module ZendeskAutomator
  class Logger
    def initialize path = STDOUT
      $logger
    end
  end
end
