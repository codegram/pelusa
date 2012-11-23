module Pelusa
  class Analyzer
    # Public: Initializes an Analyzer.
    #
    # ast      - The abstract syntax tree to analyze.
    # reporter - The class that will be used to create the report.
    # filename - The name of the file that we're analyzing.
    def initialize(lints, reporter, filename)
      @lints    = lints
      @reporter = reporter.new(filename)
    end

    # Public: Makes a report out of several classes contained in the AST.
    #
    # ast - The abstract syntax tree to analyze.
    #
    # Returns a Report of all the classes.
    def analyze(ast)
      reports = extract_classes(ast).map do |klass|
        class_analyzer = ClassAnalyzer.new(klass)
        class_name     = class_analyzer.class_name
        type           = class_analyzer.type
        analysis       = class_analyzer.analyze(@lints)

        Report.new(class_name, type, analysis)
      end
      @reporter.reports = reports
      @reporter
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
      ast.walk do |continue, node|
        if node.is_a?(Rubinius::AST::Class) || node.is_a?(Rubinius::AST::Module)
          classes << node
        end
        true
      end
      classes
    end
  end
end
