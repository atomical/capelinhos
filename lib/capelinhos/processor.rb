module Capelinhos
  class Processor
    def self.kill_memory_hogs!(memory_threshold:, process_limit:)
      processes_killed = 0
      stats = AdminTools::MemoryStats.new
      processes = stats.passenger_processes

      processes.each do |process|
        if process.name.include?('RubyApp')
          rss_megabytes = process.rss / 1024
          if rss_megabytes > memory_threshold
            Process.kill('USR1', process.pid)
            processes_killed += 1
          end

          if processes_killed >= process_limit
            break
          end
        end
      end
    end
  end
end
