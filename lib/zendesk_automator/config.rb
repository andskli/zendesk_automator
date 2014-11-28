module ZendeskAutomator
  class Config
    attr_reader :zendesk_url, :zendesk_username, :zendesk_token,
        :schedules, :tasks, :config_path

    def dryrun=(dryrun)
      @dryrun = dryrun
    end

    def dryrun
      @dryrun ||= false
    end

    def read(path)
      @config_path = path
      unless File.file?(@config_path)
        puts "Yikes, #{@config_path} is not a valid file"
        $logger.warn "Exiting, #{@config_path} is not a valid file!"
        exit 1
      end
      values = YAML::load_file(@config_path)

      $logger.debug "Got values from #{@config_path}: #{values}"

      @zendesk_url = values['zendesk']['url']
      @zendesk_username = values['zendesk']['username']
      @zendesk_token = values['zendesk']['token']
      @schedules = values.fetch('schedules')
      @tasks = values.fetch('tasks')
    end

    def reload!
      read(@config_path)
    end

  end
end
