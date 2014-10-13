require 'logger'
require 'thor'
require 'backup_monitor/checker'

module BackupMonitor
	class CLI < Thor
		def initialize
			$logger = Logger.new
			$logger.level = Logger::INFO
		end


		desc 'check', 'Checks a directory of directories for modification times'
		method_option :threshold, aliases: '-t', desc: 'Warning threshold, in seconds', type: :numeric, default: 300
		def check(base_path = nil)
			base_path ||= Dir.pwd

			checker = Checker.new warning_threshold: options[:threshold].to_i
			result = checker.check base_path
			if result.empty?
				STDOUT.puts 'No stale directories found'
			else
				STDERR.puts 'Found stale directories:'
				result.each_pair do |key, value|
					STDERR.puts "\t#{value} - #{key}"
				end
			end
		end

		default_task :check
	end
end
