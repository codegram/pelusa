module Pelusa
  class Runner
    # Public: Initializes an Analyzer.
    #
    # lints    - The lints to check the code for.
    # reporter - The Reporter to use. Will be used to report back the results in
    #            methods such as #run.
    def initialize(lints, reporter=RubyReporter)
      @lints    = lints
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
      ast      = Rubinius::Melbourne.parse_file(file)
      analyzer = Analyzer.new(@lints, @reporter)
      analyzer.analyze(ast)
    end
  end
end
