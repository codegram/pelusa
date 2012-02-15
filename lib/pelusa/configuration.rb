module Pelusa
  # Public: Class providing configuration for the runner and lints
  #
  # Examples
  #
  #   configuration = Pelusa::Configuration.new('my_pelusa_config.yml')
  #   configuration.present? # => true
  #
  class Configuration
    YAML_PATH = './.pelusa.yml'

    # Public: Initializes a configuration instance
    #
    # yaml_path - optional path to the configuration file
    def initialize(yaml_path = YAML_PATH)
      if File.exist?(yaml_path)
        @_configuration = YAML.load_file(yaml_path).freeze
      end
    end

    # Public: Returns if a custom configuration is present
    #
    # Examples
    #
    #   Pelusa.configuration.present? # => true
    #
    def present?
      not @_configuration.nil?
    end

    # Public: Returns custom configuration for the given lint
    #
    # Examples
    #
    #   Pelusa.configuration['LineRestriction'] # => {'limit' => 50}
    #
    # name - the name of the lint
    def [](name)
      for_lint(name)
    end

    # Public: Returns path to sources that should be analyzed
    #
    # Examples
    #
    #   Pelusa.configuration.sources # => lib/**/*.rb
    #
    def sources
      @_configuration['sources']
    end

    # Public: Returns an Array of enabled lints
    #
    # Examples
    #
    #   Pelusa.configuration.enabled_lints # => [ Pelusa::Lint::DemeterLaw ]
    #
    def enabled_lints
      (Lint.all - disabled_lints).uniq
    end

    #######
    private
    #######

    # Private: Returns a Hash of configuration for lints
    def lints
      @_configuration.fetch('lints', {})
    end

    # Private: Returns an Array of lints disabled in the configuration
    def disabled_lints
      lints.select { |lint, conf| conf['enabled'] === false }.map do |lint,|
        Lint.const_get(lint)
      end
    end

    # Private: Public: Returns custom configuration for the given lint
    def for_lint(name)
      lints.fetch(name, {})
    end

  end # class Configuration
end # module Pelusa
