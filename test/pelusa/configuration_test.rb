require 'test_helper'

module Pelusa
  describe Configuration do
    let(:configuration) do
      Pelusa::Configuration.new("#{FIXTURES_PATH}/sample_config_one.yml")
    end

    describe "#present?" do
      it "returns false when configuration doesn't file exists" do
        configuration = Pelusa::Configuration.new("#{FIXTURES_PATH}/not_here.yml")
        configuration.present?.must_equal(false)
      end

      it "returns false when configuration file exists" do
        configuration.present?.must_equal(true)
      end
    end

    describe '#sources' do
      it 'returns path to sources' do
        configuration.sources.must_equal 'lib/**/*.rb'
      end

      describe 'by default' do
        it 'returns lib/**/*.rb' do
          empty_configuration = Pelusa::Configuration.new("unexistent_yml")
          empty_configuration.sources.must_equal 'lib/**/*.rb'
        end
      end
    end

    describe '#enabled_lints' do
      let(:enabled_lints) { Lint.all - [ Pelusa::Lint::ElseClauses ] }

      it 'returns all enabled lints' do
        configuration.enabled_lints.must_equal(enabled_lints)
      end
    end

    describe '#[]' do
      describe 'when lint configuration exists' do
        let(:lint_configuration) { configuration['LineRestriction'] }

        it 'returns a configuration hash for the given lint' do
          lint_configuration.must_be_instance_of(Hash)
        end

        it 'must return valid configuration' do
          lint_configuration['limit'].must_equal(80)
        end
      end

      describe "when lint configuration doesn't exist" do
        let(:lint_configuration) { configuration['DemeterLaw'] }

        it 'returns an empty configuration hash' do
          lint_configuration.must_equal({})
        end
      end
    end
  end
end
