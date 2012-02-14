require 'set'
require 'pelusa/lint/line_restriction'
require 'pelusa/lint/instance_variables'
require 'pelusa/lint/demeter_law'
require 'pelusa/lint/indentation_level'
require 'pelusa/lint/else_clauses'

module Pelusa
  # Public: A Lint is a quality standard, applicable on a given piece of code to
  # check its compliance.
  #
  module Lint
    def self.all
      [
        LineRestriction,
        InstanceVariables,
        DemeterLaw,
        IndentationLevel,
        ElseClauses,
      ]
    end
  end
end
