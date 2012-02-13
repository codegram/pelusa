module Pelusa
  # Public: A Lint is a quality standard, applicable on a given piece of code to
  # check its compliance.
  #
  class Lint
    @@lints = []
    def self.all; @@lints; end
    def self.inherited(lint)
      @@lints << lint
    end
    def self.name(name); @name = name; end
    def self.name; @name; end

    def pass
      self.class.name
    end
  end

  class LineRestrictionLint < Lint
    name "Is below 50 lines"
    def report(payload, &block)

    end

    def check(klass)
      lines = []

      iterate = Iterator.new do |node|
        lines << node.line if node.respond_to?(:line)
      end

      difference = lines.max - lines.min

      pass(difference) do
        difference < 50
      end

      report "Is below 50 lines" do
        Array(ast).each(&iterate)
        num = lines.max - lines.min
        if num < 50
          Report.new
        else
          Report.new(num) { |lines| "This class has #{num} lines." }
        end
      end

    end
  end
end
