module Pelusa

  # Class providing configuration options
  #
  class Configuration
    YAML_PATH = './.pelusa.yml'

    # Initialize a configuration instance
    #
    # @param [String] optional path to the configuration file
    #
    # @api public
    def initialize(yaml_path = YAML_PATH)
      if File.exist?(yaml_path)
        @_configuration = YAML.load_file(yaml_path).freeze
      end
    end

    # @api public
    def present?
      not @_configuration.nil?
    end

    # @api public
    def [](name)
      for_lint(name)
    end

    # @api public
    def sources
      @_configuration['sources']
    end

    # @api public
    def enabled_lints
      (Lint.all - disabled_lints).uniq
    end

    # @api public
    def for_lint(name)
      lints.fetch(name, {})
    end

  private

    # @api private
    def lints
      @_configuration.fetch('lints', {})
    end

    # @api private
    def disabled_lints
      lints.select { |lint, conf| conf['enabled'] === false }.map do |lint,|
        Lint.const_get(lint)
      end
    end

  end # class Configuration
end # module Pelusa
