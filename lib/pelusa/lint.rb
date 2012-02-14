require 'set'
require 'pelusa/lint/line_restriction'

module Pelusa
  # Public: A Lint is a quality standard, applicable on a given piece of code to
  # check its compliance.
  #
  module Lint
    def self.all
      [ LineRestriction ]
    end
  end
end
