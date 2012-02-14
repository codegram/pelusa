module Pelusa
  # Public: A Report is a wrapper that relates a class name with all its
  # analyses for different lint checks.
  #
  class Report
    # Public: Initializes a new Report.
    #
    # class_name - The Symbol name of the class being analyzed.
    # analyses   - An Array of Analysis objects.
    def initialize(class_name, analyses)
      @class_name = class_name
      @analyses   = analyses
    end

    def class_name
      @class_name
    end

    def analyses
      @analyses
    end

    def successful?
      @analyses.all? { |analysis| analysis.successful? }
    end
  end
end
