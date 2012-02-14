require 'test_helper'

module Pelusa
  describe RubyReporter do
    describe '#report' do
      before do
        too_many_lines = FailedAnalysis.new("Is below 50 lines", 200) do |lines|
          "There are #{lines} lines."
        end
        okay = SuccessfulAnalysis.new("Is below 50 lines")

        @reports =  [
          Report.new("Foo", [ too_many_lines ]),
          Report.new("Bar", [ okay ])
        ]

        @reporter = RubyReporter.new('foo.rb')
        @reporter.reports = @reports
      end

      it 'returns a hashified version of the reports' do
        @reporter.report.must_equal({
          "Foo" => {
            "Is below 50 lines" => {
              status: "failed",
              message: "There are 200 lines."
            }
          },

          "Bar" => {
            "Is below 50 lines" => {
              status: "successful",
              message: ""
            }
          },

          :filename => "foo.rb"
        })
      end
    end
  end
end
