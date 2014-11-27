module ZendeskAutomator
  class Config
    attr_reader :zendesk_url, :zendesk_username, :zendesk_token,
        :schedules, :tasks

    def read(path)
      unless File.file?(path)
        puts "Yikes, #{path} is not a valid file"
        $logger.warn "Exiting, #{path} is not a valid file!"
        exit 1
      end
      values = YAML::load_file(path)

      @zendesk_url = values['zendesk']['url']
      @zendesk_username = values['zendesk']['username']
      @zendesk_token = values['zendesk']['token']
      @schedules = values['schedules']
      @tasks = values['tasks']
    end

  end
end
