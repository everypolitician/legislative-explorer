# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'
require 'reek/rake/task'

Rake::TestTask.new do |t|
  t.warning = false
  t.verbose = true
  t.description = 'Run all tests'
  t.test_files = FileList['t/**/*.rb']
  t.libs << 't'
end

RuboCop::RakeTask.new

Reek::Rake::Task.new do |t|
  t.source_files = FileList['**/*.rb']
  t.verbose = false
  t.fail_on_error = true
end

# Check for known vulnerabilities in Gemfile.lock
require 'bundler/audit/task'
Bundler::Audit::Task.new

task default: ['test', 'rubocop', 'reek', 'bundle:audit']
