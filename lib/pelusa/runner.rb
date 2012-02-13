module Pelusa
  class Runner
    # Public: Initializes an Analyzer.
    #
    # reporter - The Reporter to use. Will be used to report back the results in
    #            methods such as #run.
    def initialize(reporter=RubyReporter)
      @parser   = Rubinius::Melbourne
      @reporter = reporter
    end

    # Public: Runs the analyzer on a set of files.
    #
    # Returns an Array of Reports of those file runs.
    def run(files)
      threads = Array(files).map do |file|
        Thread.new { run_file(file) }
      end
      threads.map!(&:join)
      threads.map(&:value)
    end

    # Public: Runs the analyzer on a single file.
    #
    # Returns a Report of the single run.
    def run_file(file)
      ast    = @parser.parse_file(file)
      report = Analyzer.new(ast, @reporter).analyze
    end
  end
end
