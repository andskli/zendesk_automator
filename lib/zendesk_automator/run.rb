module ZendeskAutomator
  class Run

    def initialize(options)
      # Read config
      @config = Config.new
      @config.read(options[:config_path])
      @dryrun = options[:dry_run]

      #$logger.debug "DRY-RUN: #{options[:dry_run]}"
      #$logger.debug "Found schedules: #{config.schedules}"
      #$logger.debug "Found tasks: #{config.tasks}"

      @client = Client.new(@config.zendesk_url, @config.zendesk_username, @config.zendesk_token)
      @jobs = []
      @scheduler = Rufus::Scheduler.new

      schedule_tasks!(@config)

      trap 'HUP' do
        t = Thread.new do
          $logger.info "Reloading config!"
          @jobs.count.times do
            job = @jobs.shift
            $logger.debug "Trying to unschedule #{job}"
            job.unschedule
          end
          @config.reload!
          schedule_tasks!(@config)
        end
      end

      @scheduler.join

    end

    def schedule_tasks!(config)
      config.tasks.each do |task, ticket_params|
        schedule_name = ticket_params['schedule']
        cron_str = config.schedules[schedule_name]['cron']

        $logger.debug "Trying to schedule #{task} with cron schedule '#{cron_str}'"

        @scheduler.cron "#{cron_str}" do |job|
          t = Ticket.new
          t.dryrun = true if @dryrun
          t.create(ticket_params)
          @jobs << job
        end
      end

    end

  end
end
