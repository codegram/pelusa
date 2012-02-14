module Pelusa
  class Analysis
    def initialize(name)
      @name = name
    end

    def name
      @name
    end

    def successful?
      raise NotImplementedError
    end

    def failed?
      not successful?
    end

    def message
      ""
    end
  end

  class SuccessfulAnalysis < Analysis
    def successful?
      true
    end
  end

  class FailedAnalysis < Analysis
    def initialize(name, payload, &block)
      super(name)
      @payload = payload
      @block   = block
    end

    def successful?
      false
    end

    def message
      @block.call(@payload)
    end
  end
end
