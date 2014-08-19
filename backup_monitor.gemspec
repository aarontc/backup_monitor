# coding: utf-8
lib = File.expand_path '../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib
require 'backup_monitor/version'

Gem::Specification.new do |spec|
	spec.name          = 'backup_monitor'
	spec.version       = BackupMonitor::VERSION
	spec.authors       = ['Aaron Ten Clay']
	spec.email         = ['backup_monitor_gem@aarontc.com']
	spec.summary       = %q{Checks the modification age of a directory hierarchy to locate stale backups.}
	spec.description   = spec.summary
	spec.homepage      = 'https://github.com/AaronTC/backup_monitor'
	spec.license       = 'MIT'

	spec.files         = `git ls-files -z`.split "\x0"
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep %r{^(test|spec|features)/}
	spec.require_paths = %w[lib]

	%w[coalesce thor].each do |gem|
		spec.add_dependency gem
	end

	spec.add_development_dependency 'bundler', '~> 1.6'
	%w[fakefs minitest minitest-ci rake rr simplecov simplecov-rcov spork spork-minitest].each do |gem|
		spec.add_development_dependency gem
	end
end
