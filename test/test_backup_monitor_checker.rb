require_relative 'helper'

require 'backup_monitor/checker'

class TestBackupMonitorChecker < Minitest::Test
	def test_with_two_old_backups
		mock(BackupMonitor::DirectoryHierarchyModificationTime).modification_time('/backups/host1.domain') { Time.new 2014, 7, 14, 16, 15, 22, '-07:00' }
		mock(BackupMonitor::DirectoryHierarchyModificationTime).modification_time('/backups/host2.domain') { Time.new 2014, 8, 2, 1, 3, 5, '-07:00' }
		mock(BackupMonitor::DirectoryHierarchyModificationTime).modification_time('/backups/host3.otherdomain') { Time.new 2014, 2, 4, 22, 45, 8, '-07:00' }
		mock(FakeFS::Dir).[]('/backups/*') { %w[. .. host1.domain host2.domain host3.otherdomain].shuffle }
		mock(FakeFS::File).directory?('/backups/host1.domain') { true }
		mock(FakeFS::File).directory?('/backups/host2.domain') { true }
		mock(FakeFS::File).directory?('/backups/host3.otherdomain') { true }
		stub(Time).now { Time.new 2014, 8, 3, 16, 23, 26, '-07:00' }

		actual = nil
		FakeFS do
			uut = BackupMonitor::Checker.new warning_threshold: (3 * 24 * 60 * 60)
			stub(uut).real_path.with_any_args { stub!.join.with_any_args { |x| "/backups/#{x}" } }
			actual = uut.check '/backups'
		end

		expected = {
			'/backups/host1.domain' => Time.new(2014, 7, 14, 16, 15, 22, '-07:00'),
			'/backups/host3.otherdomain' => Time.new(2014, 2, 4, 22, 45, 8, '-07:00')
		}

		assert_equal expected, actual, 'Checker did not return expected list of outdated directories'
	end


	def test_with_no_old_backups
		mock(BackupMonitor::DirectoryHierarchyModificationTime).modification_time('/backups/other/host44.domain') { Time.new 2014, 8, 2, 7, 32, 16, '-07:00' }
		mock(BackupMonitor::DirectoryHierarchyModificationTime).modification_time('/backups/other/host45.domain') { Time.new 2014, 8, 2, 2, 17, 52, '-07:00' }
		mock(BackupMonitor::DirectoryHierarchyModificationTime).modification_time('/backups/other/host46.otherdomain') { Time.new 2014, 8, 2, 4, 3, 41, '-07:00' }
		mock(FakeFS::Dir).[]('/backups/other/*') { %w[. .. host44.domain host45.domain host46.otherdomain].shuffle }
		mock(FakeFS::File).directory?('/backups/other/host44.domain') { true }
		mock(FakeFS::File).directory?('/backups/other/host45.domain') { true }
		mock(FakeFS::File).directory?('/backups/other/host46.otherdomain') { true }
		stub(Time).now { Time.new 2014, 8, 3, 16, 23, 26, '-07:00' }

		actual = nil
		FakeFS do
			uut = BackupMonitor::Checker.new warning_threshold: (3 * 24 * 60 * 60)
			stub(uut).real_path.with_any_args { stub!.join.with_any_args { |x| "/backups/other/#{x}" } }
			actual = uut.check '/backups/other'
		end

		expected = {}
		assert_equal expected, actual, 'Checker did not return empty hash with no old backups for #check'
	end
end
