require 'json'
require 'net/http'
require 'byebug' if ENV['DEBUG']

module Capelinhos
  class Processor
    def initialize(memory_threshold:, process_limit:)
      @memory_threshold = memory_threshold
      @process_limit = process_limit
    end

    def kill_memory_hogs!
      processes_killed = 0
      stats = AdminTools::MemoryStats.new
      processes = stats.passenger_processes

      if !supports_private_dirty_rss?(processes)
        puts "This system doesn't support private dirty RSS. Falling back to RSS"
      end

      rss_type = supports_private_dirty_rss?(processes) ? :private_dirty_rss : :rss

      processes.each do |process|
        if process.name.include?('RubyApp')
          rss_megabytes = process.send(rss_type) / 1024
          if rss_megabytes > @memory_threshold
            shutdown_process(process.pid)
            processes_killed += 1
          end

          if processes_killed >= @process_limit
            break
          end
        end
      end
    end

    private

    def supports_private_dirty_rss?(processes)
      processes.any?{|p| !p.private_dirty_rss.nil?}
    end

    def shutdown_process(pid)
      _instance = instance
      request = Net::HTTP::Post.new("/pool/detach_process.json")
      request.body = JSON.generate({pid: pid})
      try_performing_ro_admin_basic_auth(request, _instance)
      response = _instance.http_request("agents.s/core_api", request)

      if response.code.to_i / 100 == 2
        puts "Successfully detached PID: #{pid}"
      else
        puts "Process (#{pid}) could not be shutdown: #{response.body}"
      end
    end

    def instance
      instances = InstanceRegistry.new.list
      instances.first
    end

    def try_performing_ro_admin_basic_auth(request, instance)
      begin
        password = instance.read_only_admin_password
      rescue Errno::EACCES
        return
      end
      request.basic_auth("ro_admin", password)
    end
  end
end
