class Pelusa::ClassAnalyzer
  # Public: Initializes a ClassAnalyzer.
  #
  # klass - The class AST node.
  def initialize(klass)
    @klass = klass
  end

  # Public: Analyzes a class with a series of lints.
  #
  # lints - The lints to check for.
  #
  # Returns a collection of Analysis, one for each lint.
  def analyze(lints)
    lints.map do |lint|
      lint.check(@klass)
    end
  end
end
