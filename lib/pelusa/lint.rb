require 'set'
require 'pelusa/lint/line_restriction'
require 'pelusa/lint/instance_variables'

module Pelusa
  # Public: A Lint is a quality standard, applicable on a given piece of code to
  # check its compliance.
  #
  module Lint
    def self.all
      [
        LineRestriction,
        InstanceVariables,
      ]
    end
  end
end
