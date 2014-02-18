# IATACode

Automate finding IATA codes/airlines from their search page.

http://www.iata.org/publications/Pages/code-search.aspx

## Installation

After cloning repository:

    $ bundle
    $ bundle exec rake install

## Usage

Search IATA codes by given airline name (also partial) or code:

CLI: 

    $ iata_code find lufthansa
    Deutsche Lufthansa AG: LH
    Lufthansa Cargo AG: LH
    Lufthansa CityLine GmbH: CL
    Lufthansa Systems AG: S1
    
    $ iata_code find SK
    Scandinavian Airlines System (SAS): SK
    
Plain Ruby:

```ruby
IATACode.lookup("lufthansa") // => {"Deutsche Lufthansa AG"=>"LH", "Lufthansa Cargo AG"=>"LH", "Lufthansa CityLine GmbH"=>"CL", "Lufthansa Systems AG"=>"S1"}
```
