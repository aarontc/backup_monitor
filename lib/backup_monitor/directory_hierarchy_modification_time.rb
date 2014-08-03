class DirectoryHierarchyModificationTime
	# TODO: This is slow and kludgy
	def self.modification_time(root_path)
		newest_mtime = nil
		newest_path = nil
		Dir["#{root_path}/**"].each do |f|
			next if File.directory? f
			mtime = File.mtime f
			if newest_mtime.nil? or mtime > newest_mtime
				newest_mtime = mtime
				newest_path = f
			end
		end
		newest_mtime
	end
end
