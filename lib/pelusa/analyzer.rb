module Pelusa
  class Analyzer
    # Public: Initializes an Analyzer.
    #
    # ast      - The abstract syntax tree to analyze.
    # reporter - The class that will be used to create the report.
    def initialize(ast, reporter)
      @ast      = ast
      @reporter = reporter
    end

    # Public: Makes a report out of several classes contained in the AST.
    #
    # Returns a Report of all the classes.
    def analyze
      results = extract_classes.map do |klass|
        class_analyzer = ClassAnalyzer.new(klass)
        class_analyzer.analyze
      end
      @reporter.new(results)
    end

    #######
    private
    #######

    # Internal: Extracts the classes out of the AST and returns their nodes.
    #
    # Returns an Array of Class nodes.
    def extract_classes
      classes = []
      class_iterator = Iterator.new do |node|
        classes << node if node.is_a?(Rubinius::AST::Class)
      end
      Array(@ast).each(&class_iterator)
      classes
    end
  end
end
