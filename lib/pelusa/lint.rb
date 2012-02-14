require 'set'
require 'pelusa/lint/line_restriction'
require 'pelusa/lint/instance_variables'
require 'pelusa/lint/demeter_law'
require 'pelusa/lint/indentation_level'
require 'pelusa/lint/else_clauses'
require 'pelusa/lint/properties'
require 'pelusa/lint/collection_wrappers'
require 'pelusa/lint/short_identifiers'

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
        Properties,
        CollectionWrappers,
        ShortIdentifiers,
      ]
    end
  end
end
