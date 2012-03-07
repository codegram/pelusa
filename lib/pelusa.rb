module Pelusa
  # Public: Runs the runner on a set of files.
  #
  # Returns an Array of results of a given Reporter
  def self.run(files=[], reporter=StdoutReporter)
    lints  = configuration.enabled_lints
    runner = Runner.new(lints, reporter)
    runner.run(files)
  end

  # Return configuration
  def self.configuration
    @configuration ||= Configuration.new
  end
end

require 'yaml'

require 'pelusa/configuration'
require 'pelusa/cli'
require 'pelusa/runner'
require 'pelusa/analyzer'
require 'pelusa/lint'
require 'pelusa/analysis'
require 'pelusa/class_analyzer'
require 'pelusa/report'
require 'pelusa/iterator'


require 'pelusa/reporters/reporter'
require 'pelusa/reporters/stdout_reporter'
require 'pelusa/reporters/ruby_reporter'
