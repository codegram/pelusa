module Pelusa
  # Public: Runs the runner on a set of files.
  #
  # Returns an Array of Reports of those file runs.
  def self.run(files=Dir["**/*.rb"])
    Runner.new.run(files)
  end
end

require 'pelusa/runner'
require 'pelusa/analyzer'
require 'pelusa/class_analyzer'
require 'pelusa/iterator'
require 'pelusa/reporters/ruby_reporter'
