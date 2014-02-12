# IATACode

Automate finding IATA codes from their search page.

## Installation

After cloning repository:

    $ bundle
    $ bundle exec rake install

## Usage

CLI: search IATA codes by given airline name

    $ iata_code find lufthansa
    Deutsche Lufthansa AG: LH
    Lufthansa Cargo AG: LH
    Lufthansa CityLine GmbH: CL
    Lufthansa Systems AG: S1
    
Plain Ruby:

```ruby
result = IATACode::Scraper.new.scrape("lufthansa") // => {"Deutsche Lufthansa AG"=>"LH", "Lufthansa Cargo AG"=>"LH", "Lufthansa CityLine GmbH"=>"CL", "Lufthansa Systems AG"=>"S1"}
```
