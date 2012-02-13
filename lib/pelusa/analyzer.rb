module Pelusa
  class Analyzer
    # Public: Initializes an Analyzer.
    #
    # ast      - The abstract syntax tree to analyze.
    # reporter - The class that will be used to create the report.
    def initialize(lints, reporter)
      @lints    = lints
      @reporter = reporter
    end

    # Public: Makes a report out of several classes contained in the AST.
    #
    # ast - The abstract syntax tree to analyze.
    #
    # Returns a Report of all the classes.
    def analyze(ast)
      results = extract_classes(ast).map do |klass|
        class_analyzer = ClassAnalyzer.new(klass)
        class_analyzer.analyze(@lints)
      end
      @reporter.new(results)
    end

    #######
    private
    #######

    # Internal: Extracts the classes out of the AST and returns their nodes.
    #
    # ast - The abstract syntax tree to extract the classes from.
    #
    # Returns an Array of Class nodes.
    def extract_classes(ast)
      classes = []
      class_iterator = Iterator.new do |node|
        classes << node if node.is_a?(Rubinius::AST::Class)
      end
      Array(ast).each(&class_iterator)
      classes
    end
  end
end
