module Pelusa
  module Lint
    class ShortIdentifiers
      RESERVED_NAMES = ['p', 'pp', 'id']

      def initialize
        @violations = Set.new
      end

      def check(klass)
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, formatted_violations) do |violations|
          "Names are too short: #{violations.join(', ')}"
        end
      end

      private

      def name
        "Uses descriptive names"
      end

      def iterate_lines!(klass)
        ClassAnalyzer.walk(klass) do |node|
          if node.respond_to?(:name)
            name = node.name.respond_to?(:name) ? node.name.name.to_s : node.name.to_s
            if name =~ /[a-z]/ && name.length < 3 && !RESERVED_NAMES.include?(name)
              @violations << [name, node.line] unless name =~ /^[A-Z]/ # Ignore constants
            end
          end
        end
      end

      def formatted_violations
        grouped_violations = @violations.inject({}) do |hash, (name, line)|
          hash[name] ||= []
          hash[name] << line
          hash
        end

        violations = []

        grouped_violations.each_pair do |name, lines|
          violations << "#{name} (line #{lines.join(', ')})"
        end
        violations
      end
    end
  end
end
