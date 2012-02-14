module Pelusa
  module Lint
    class ShortIdentifiers
      def initialize
        @violations = Set.new
      end

      def check(klass)
        initialize
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
        iterator = Iterator.new do |node|
          if node.respond_to?(:name)
            name = node.name.respond_to?(:name) ? node.name.name.to_s : node.name.to_s
            if name =~ /[a-z]/ && name.length < 3 && !["p", "pp"].include?(name)
              next if name =~ /^[A-Z]/ # Ignore constants
              @violations << [name, node.line]
            end
          end
        end
        Array(klass).each(&iterator)
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
