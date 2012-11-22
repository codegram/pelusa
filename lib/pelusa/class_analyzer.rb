class Pelusa::ClassAnalyzer
  # Public: Initializes a ClassAnalyzer.
  #
  # klass - The class AST node.
  def initialize(klass)
    @klass = klass
  end

  # Public: Returns the name of the Class being analyzed.
  #
  # Returns the String name.
  def class_name
    name = @klass.name
    name.name
  end

  # Public: Returns the type of container being examined (class or module).
  def type
    @klass.is_a?(Rubinius::AST::Class) ? "class" : "module"
  end

  # Public: Analyzes a class with a series of lints.
  #
  # lints - The lints to check for.
  #
  # Returns a collection of Analysis, one for each lint.
  def analyze(lints)
    lints.map do |lint_class|
      lint = lint_class.new
      lint.check(@klass)
    end
  end

  # Public: Walk a node, analyzing it as it goes.
  #
  # block - supply a block that will be executed as the node gets walked.
  def self.walk(start_node)
    raise ArgumentError, "Walk requires a block!" unless block_given?
    start_node.walk do |continue, node|
      yield(node)
      true
    end
  end
end
