require 'coalesce'
require 'pathname'
require 'backup_monitor/directory_hierarchy_modification_time'

module BackupMonitor
	class Checker
		def initialize(options = {})
			@warning_threshold = options.delete(:warning_threshold)._? { raise ArgumentError, ':warning_threshold (seconds) must be supplied in options hash' }
		end

		def check(path)
			pathname = real_path path
			result = {}
			Dir[pathname.join('*')].each do |d|
				full_path = pathname.join d
				next if %w[. ..].include? d
				next unless File.directory? full_path
				dir_mtime = DirectoryHierarchyModificationTime.modification_time full_path
				if dir_mtime.nil?
					# No files in the tree
					result[full_path] = Time.at(0)
				else
					result[full_path] = dir_mtime if (Time.now - dir_mtime).to_i > @warning_threshold
				end
			end
			result
		end


		# This method wrapper exists solely for testing due to some outstanding bugs in FakeFS
		def real_path(path)
			Pathname.new(path).realpath
		end
	end
end
