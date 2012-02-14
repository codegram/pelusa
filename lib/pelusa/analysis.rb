module Pelusa
  # Public: An Analysis the result of applying a Lint check to a class.
  #
  # Examples
  #
  #   analysis = SuccessfulAnalysis.new("Is below 50 lines")
  #   analysis.successful?
  #   # => true
  #
  #   failure = FailedAnalysis.new("Is below 50 lines", 123) do |lines|
  #     "There are too many lines (#{lines})"
  #   end
  #   failure.successful?
  #   # => false
  #   failure.message
  #   # => "There are too many lines (123)"
  #
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

    def status
      successful? ? "successful" : "failed"
    end
  end

  # Public: A SuccessfulAnalysis is an analysis that has passed a particular
  # lint check.
  #
  class SuccessfulAnalysis < Analysis
    # Public: A successful analysis is always successful, obviously.
    #
    # Returns true.
    def successful?
      true
    end
  end

  # Public: A FailedAnalysis is an analysis that has failed a particular
  # lint check.
  #
  class FailedAnalysis < Analysis
    # Public: Initializes a new FailedAnalysis.
    #
    # name    - The name of the lint check.
    # payload - An object to use in the message to aid the user in fixing the
    #           problem.
    # block   - A block to generate the message. It must yield the payload
    #           object.
    def initialize(name, payload, &block)
      super(name)
      @payload = payload
      @block   = block
    end

    # Public: A failed analysis is never successful , obviously.
    #
    # Returns false.
    def successful?
      false
    end

    # Public: Generates an explicative message yielding the payload object to
    # the block, so that the user gets some hint to fix the problem.
    #
    # Returns the String message.
    def message
      @block.call(@payload)
    end
  end
end
