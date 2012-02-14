module Pelusa
  class Reporter
    def self.print_banner
    end

    def initialize(filename)
      @filename = filename
    end

    def reports=(reports)
      @reports = reports
    end

    def report
      raise NotImplementedError
    end
  end
end
