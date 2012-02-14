module Pelusa
  # Public: Runs the runner on a set of files.
  #
  # Returns an Array of Reports of those file runs.
  def self.run(files = [], lints=Lint.all)
    if files.empty?
      files = Dir["**/*.rb"]
    end

    runner = Runner.new(lints)
    runner.run(files)
  end
end

require 'pelusa/runner'
require 'pelusa/analyzer'
require 'pelusa/lint'
require 'pelusa/analysis'
require 'pelusa/class_analyzer'
require 'pelusa/report'
require 'pelusa/iterator'
require 'pelusa/reporters/ruby_reporter'
