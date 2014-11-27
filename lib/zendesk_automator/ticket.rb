module ZendeskAutomator
  class Ticket

      def dryrun=(val)
        @dryrun = val
      end

      def dryrun
        @dryrun ||= false
      end

      def create(ticket_params)
        params = sanitize(ticket_params)

        ticket_params.delete(:schedule)

        begin
          unless @dryrun
            $logger.info "Trying to create ticket with params: #{params}"
            $zendesk_client.tickets.create(ticket_params)
          else
            $logger.info "Dry-run requested, would have created ticket with params: #{params}"
          end
          return true
        rescue ZendeskAPI::Error => e
          $logger.warn "ZendeskAPI Error: #{e}"
          return false
        end
      end

      def sanitize(task)
        task = keys_to_sym(task)
        task.each do |key, value|
          if value.is_a?(String)
            task[key] = erb_to_string(value)
          elsif value.is_a?(Array)
            value.map! { |v| erb_to_string(v) if v.is_a?(String) }
          end
        end
        task
      end

      def keys_to_sym(h)
        Hash[h.map { |(k, v)| [k.to_sym, v] }]
      end

      def erb_to_string(v)
        ERB.new(v).result
      end

  end
end
