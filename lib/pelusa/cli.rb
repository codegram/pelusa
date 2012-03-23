module Pelusa
  # The cli is a class responsible of handling all the command line interface
  # logic.
  #
  class Cli
    def initialize(args=ARGV)
      @args = args
    end

    def run
      _files = files
      if _files.empty?
        warn "\n  No files specified -- PROCESS ALL THE FILES!\n"
        _files = Dir["**/*.rb"]
      end

      reporters = Pelusa.run(_files)

      reporters.first.class.print_banner unless reporters.empty?

      exit_code = 0
      reporters.each do |reporter|
        reporter.report
        exit_code = 1 unless reporter.successful?
      end
      exit_code
    end

    def files
      if glob = @args.detect { |arg| arg =~ /\*/ }
        return Dir[glob]
      end
      _files = @args.select { |arg| arg =~ /\.rb/ }
      _files = Dir[Pelusa.configuration.sources] if _files.empty?
      _files
    end
  end
end
