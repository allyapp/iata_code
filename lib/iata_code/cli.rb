require "thor"

module IATACode
  class CLI < Thor
    desc "find NAME", "look up IATA codes by airline name, or an airline by a given code"
    def find(name)
      result = IATACode.lookup(name)

      puts result ? result.to_a.map { |r| r.join(": ") } : "No results"
    end
  end
end
