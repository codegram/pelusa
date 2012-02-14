module Pelusa
  class Report
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
  end
end
