require "oobp/version"

module OOBP
  def self.run(argv)
    file = argv.first
    p "Running #{file}"
  end
end
