module ZendeskAutomator

  class Run
    # @return [Hash] Returns config hash (from YAML file)
    attr_reader :config, :options

    def initialize(options)

      @options = options
      config_path = @options[:config_path]
      unless File.file?(config_path)
        puts "Yikes, #{config_path} is not a valid file!"
        $logger.warn "Exiting, #{config_path} is not a valid file!"
        exit 1
      end
      @config = YAML::load_file(config_path)

      schedules = config['schedules']
      $logger.debug "Found schedules: #{schedules}"
      tasks = config['tasks']
      $logger.debug "Found tasks: #{tasks}"

      @zendesk_client = ZendeskAPI::Client.new do |client_config|
        client_config.url = config['zendesk']['url']
        client_config.username = config['zendesk']['username']
        client_config.token = config['zendesk']['token']
        client_config.logger = $logger
      end

      # Schedule and perform create_ticket on the tasks
      scheduler = Rufus::Scheduler.new
      tasks.each do |task, params|
        schedule_name = params['schedule']
        cron_str = schedules[schedule_name]['cron']

        $logger.debug "Trying to schedule #{task} with cron schedule '#{cron_str}'"
        scheduler.cron "#{cron_str}" do
          create_ticket(params)
        end
      end
      scheduler.join

    end

    # @param [Hash] Insert a hash containing ticket attributes
    def create_ticket(params)
      today = Time::new.strftime("%Y-%m-%d %A")

      params.delete('schedule')
      
      begin
        unless @options[:dry_run]
          $logger.info "Trying to create ticket with params: #{params}"
          @zendesk_client.tickets.create(keys_to_sym(params))
        else
          $logger.info "Dry-run requested, would have created ticket with params: #{params}"
        end
        return true
      rescue ZendeskAPI::Error => e
        $logger.warn "ZendeskAPI Error: #{e}"
        return false
      end

    end

    def keys_to_sym(h)
      Hash[h.map { |(k, v)| [k.to_sym, v] }]
    end

  end

end
