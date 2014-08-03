require 'simplecov'
require 'simplecov-rcov'

# Configure code coverage
SimpleCov.coverage_dir 'build/output/coverage'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start unless SimpleCov.running

# Configure minitest
require 'minitest/pride'
require 'minitest/autorun'
require 'rr'

# Test dependencies
require 'fakefs/safe'

Minitest::Ci.clean = false
Minitest::Ci.report_dir = 'build/output/test'
