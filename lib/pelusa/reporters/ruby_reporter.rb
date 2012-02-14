# encoding: utf-8

module Pelusa
  class RubyReporter < Reporter
    def report
      hash = @reports.inject({}) do |acc, report|
        class_name = report.class_name
        acc[class_name] = hashify_report(report)
        acc
      end
      hash[:filename] = @filename unless hash.empty?
      hash
    end

    private

    def hashify_report(report)
      analyses = report.analyses
      analyses.inject({}) do |acc, analysis|
        name = analysis.name
        acc[name] = {
          status:  analysis.status,
          message: analysis.message,
        }
        acc
      end
    end
  end
end
