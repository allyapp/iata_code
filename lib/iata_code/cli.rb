require "thor"

module IATACode
  class CLI < Thor
    desc "find NAME", "find IATA code by airline name"
    def find(name)
      result = IATACode::Scraper.new.scrape(name)

      puts result ? result.to_a.map { |r| r.join(": ") } : "No results"
    end
  end
end
