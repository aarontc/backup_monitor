require_relative 'helper'

require 'backup_monitor/directory_hierarchy_modification_time'

class TestDirectoryHierarchyModificationTime < Minitest::Test
	def test_modification_time_with_some_files
		actual = nil
		expected = Time.new 2014, 8, 3, 15, 05, 01, '-07:00'

		FakeFS do
			# There is a bug in FakeFS, the following line should work but doesn't:
			#FileUtils.mkdir_p '/my_directory/some_cool/files_here'

			# This is the workaround:
			FileUtils.mkdir '/my_directory'
			FileUtils.mkdir '/my_directory/some_cool'
			FileUtils.mkdir '/my_directory/some_cool/files_here'

			FileUtils.touch '/my_directory/LICENSE.md', mtime: (expected - 1000)
			FileUtils.touch '/my_directory/some_cool/files_here/my_file.txt', mtime: expected
			FileUtils.touch '/my_directory/some_cool/README.md', mtime: (expected - 100)

			actual = DirectoryHierarchyModificationTime.modification_time '/my_directory'
		end

		assert_equal expected, actual, 'The modification time returned was incorrect'
	end


	def test_modification_time_with_no_files
		actual = nil

		FakeFS do
			# There is a bug in FakeFS, the following line should work but doesn't:
			#FileUtils.mkdir_p '/my_directory/some_cool/files_here'

			# This is the workaround:
			FileUtils.mkdir '/my_directory2'
			FileUtils.mkdir '/my_directory2/some_cool'
			FileUtils.mkdir '/my_directory2/some_cool/files_here'

			actual = DirectoryHierarchyModificationTime.modification_time '/my_directory2'
		end

		assert_nil actual, 'The modification time returned was not nil and should have been'
	end
end
