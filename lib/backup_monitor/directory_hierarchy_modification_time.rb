module BackupMonitor
	class DirectoryHierarchyModificationTime
		attr_accessor :raise_exceptions
		attr_reader :exceptions, :newest_path

		def initialize
			@raise_exceptions = true
		end


		def get_newest_modification_time(root_path)
			@raise_exceptions = false
			real_newest_modification_time root_path
		end


		def get_newest_modification_time!(root_path)
			@raise_exceptions = true
			real_newest_modification_time root_path
		end


		# TODO: This is slow and kludgy
		def real_newest_modification_time(root_path)
			@exceptions = []

			newest_mtime = nil
			@newest_path = nil
			Dir["#{root_path}/**/*"].each do |f|
				begin
					next if File.directory? f
					mtime = File.mtime f
					if newest_mtime.nil? or mtime > newest_mtime
						newest_mtime = mtime
						@newest_path = f
					end
				rescue => e
					@exceptions << e
					raise if @raise_exceptions
				end
			end
			newest_mtime
		end
	end
end
