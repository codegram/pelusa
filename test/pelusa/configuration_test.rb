require 'test_helper'

module Pelusa
  describe Configuration do
    let(:configuration) do
      Pelusa::Configuration.new("#{FIXTURES_PATH}/sample_config_one.yml")
    end

    describe '#sources' do
      it 'returns path to sources' do
        configuration.sources.must_equal 'lib/**/*.rb'
      end
    end

    describe '#enabled_lints' do
      let(:enabled_lints) { Lint.all - [ Pelusa::Lint::ElseClauses ] }

      it 'returns all enabled lints' do
        configuration.enabled_lints.must_equal(enabled_lints)
      end
    end

    describe '#[]' do
      let(:lint_configuration) { configuration['LineRestriction'] }

      it 'returns a configuration hash for the given lint' do
        lint_configuration.must_be_instance_of(Hash)
      end

      it 'must return valid configuration' do
        lint_configuration['limit'].must_equal(80)
      end
    end
  end
end
