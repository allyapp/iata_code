require "thor"

module IATACode
  class CLI < Thor
    desc "find NAME", "find IATA codes by airline name"
    def find(name)
      result = IATACode.lookup(name)

      puts result ? result.to_a.map { |r| r.join(": ") } : "No results"
    end
  end
end
