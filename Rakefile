require 'bundler/gem_tasks'
require 'bundler/setup'
require 'rake/testtask'


Rake::TestTask.new do |t|
	t.test_files = FileList['test/test_*.rb']
end


task default: :test
