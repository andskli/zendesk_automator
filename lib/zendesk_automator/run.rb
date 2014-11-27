module ZendeskAutomator
  class Run

    def initialize(options)
      # Read config
      config = Config.new
      config.read(options[:config_path])

      $logger.debug "DRY-RUN: #{options[:dry_run]}"
      $logger.debug "Found schedules: #{config.schedules}"
      $logger.debug "Found tasks: #{config.tasks}"

      # Setup ZendeskAutomator::Client
      Client.new(config.zendesk_url, config.zendesk_username, config.zendesk_token)

      # Schedule and perform create the tickets based on tasks
      scheduler = Rufus::Scheduler.new
      config.tasks.each do |task, ticket_params|
        schedule_name = ticket_params['schedule']
        cron_str = config.schedules[schedule_name]['cron']

        $logger.debug "Trying to schedule #{task} with cron schedule '#{cron_str}'"

        scheduler.cron "#{cron_str}" do
          t = Ticket.new
          t.dryrun = true if options[:dry_run]
          t.create(ticket_params)
        end
      end
      scheduler.join
    end

  end
end
