# encoding: utf-8

module Pelusa
  class StdoutReporter < Reporter
    def self.print_banner
      puts "  \e[0;35mϟ\e[0m \e[0;32mPelusa \e[0;35mϟ\e[0m"
      puts "  \e[0;37m----------\e[0m"
    end

    def report
      puts "  \e[0;36m#{@filename}\e[0m"
      puts

      @reports.each do |class_report|
        print_report(class_report)
      end
    end

    private

    def print_report(class_report)
      class_name = class_report.class_name

      puts "  class #{class_name}"

      analyses = class_report.analyses
      analyses.each do |analysis|
        print_analysis(analysis)
      end
      puts
    end

    def print_analysis(analysis)
      name    = analysis.name
      status  = analysis.status
      message = analysis.message

      print "    \e[0;33m✿ %s \e[0m" % name

      if analysis.successful?
        print "\e[0;32m✓\e[0m\n"
        return
      end

      print "\e[0;31m✗\n\t"
      puts message
      print "\e[0m"
    end
  end
end
