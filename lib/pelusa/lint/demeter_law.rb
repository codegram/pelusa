module Pelusa
  module Lint
    class DemeterLaw
      def initialize
        @violations = Set.new
      end

      def check(klass)
        initialize
        iterate_lines!(klass)

        return SuccessfulAnalysis.new(name) if @violations.empty?

        FailedAnalysis.new(name, @violations) do |violations|
          "There are #{violations.length} Demeter law violations in lines #{violations.to_a.join(', ')}."
        end
      end

      private

      def name
        "Respects Demeter law"
      end

      def iterate_lines!(klass)
        iterator = Iterator.new do |node|
          if node.is_a?(Rubinius::AST::Send) && node.receiver.is_a?(Rubinius::AST::Send)
            @violations << node.line unless white_listed?(node.receiver.name)
          end
        end
        Array(klass).each(&iterator)
      end

      # Internal: Default modules whose methods are whitelisted.
      DEFAULT_WHITELIST = [Class, Fixnum, Enumerable]

      # Internal: Methods on these common, fundamental classes and modules are
      # allowed to be called on other objects.
      #
      # Note: this doesn't currently work with namespaced objects, but would be
      # easy to extend.
      #
      # Returns an array of classes specified in .pelusa.yml (a comma-separated
      # list of class names) or the default values above.
      def whitelist_sources
        if whitelist = Pelusa.configuration['DemeterLaw']['whitelist']
          whitelist.split(",").map {|k| Kernel.const_get(k.strip)}
        else
          DEFAULT_WHITELIST
        end
      end

      # Internal: Allow conversion methods -- matching /^(to_|as_)/ to violate
      # the law of Demeter.
      def allow_conversions?
        Pelusa.configuration['DemeterLaw'].fetch('allow_conversions', false)
      end

      def white_listed? method
        whitelist_sources.any? do |enclosing_module|
          enclosing_module.instance_methods.any? do |instance_method|
            instance_method == method or
              allow_conversions? && instance_method =~ /^(to_|as_)/
          end
        end
      end
    end
  end
end
