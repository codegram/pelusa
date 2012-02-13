class Pelusa::Analyzer
  # Public: Initializes an Analyzer.
  #
  # ast      - The abstract syntax tree to analyze.
  # reporter - The class that will be used to create the report.
  def initialize(ast, reporter)
    @ast      = ast
    @reporter = reporter
  end

  def analyze
  end
end
