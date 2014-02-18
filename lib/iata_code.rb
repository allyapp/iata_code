require "iata_code/version"
require "iata_code/scraper"
require "iata_code/cli"

module IATACode
  def self.lookup(name)
    IATACode::Scraper.new.scrape(name)
  end
end
