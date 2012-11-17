module Pelusa
  # Public: A Report is a wrapper that relates a class name with all its
  # analyses for different lint checks.
  #
  class Report
    # Public: Initializes a new Report.
    #
    # class_name - The Symbol name of the class being analyzed.
    # type       - the String type of the class being analyzed (class or module).
    # analyses   - An Array of Analysis objects.
    def initialize(name, type, analyses)
      @class_name = name
      @type       = type
      @analyses   = analyses
    end

    attr_reader :class_name, :type, :analyses

    def successful?
      @analyses.all? { |analysis| analysis.successful? }
    end
  end
end
