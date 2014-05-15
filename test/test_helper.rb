require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'

require 'pelusa'

FIXTURES_PATH = File.dirname(__FILE__) + '/fixtures'

module Pelusa
  def self.to_ast(string)
    ::Rubinius::ToolSets.current::ToolSet::Melbourne.parse_string(string)
  end
end
