require "capybara"
require "capybara/dsl"
require "capybara/poltergeist"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end
Capybara.default_driver = :poltergeist
Capybara.default_wait_time = 10
Capybara.run_server = false
Capybara.app_host = "http://www.iata.org"

module IATACode
  class CapybaraEngine
    include Capybara::DSL

    def scrape(url, airline_name)
      @results ||= query_results(url, airline_name)
    end

    private

    def query_results(url, name)
      visit(url)
      choose_search_by_airline_name
      enter_airline_name(name)
      submit_form
      wait_for_results(name)
      parse_results
    rescue Capybara::ElementNotFound => e
      puts "#{e}"
    end

    def choose_search_by_airline_name
      select("Airline name", from: find(".ajaxForm select")[:id])
    end

    def enter_airline_name(name)
      fill_in(find(".ajaxForm input[type=text]")[:id], :with => name)
    end

    def submit_form
      find(".ajaxForm input[type=submit]").click
    end

    def wait_for_results(name)
      # Either 'No results for "Foo"' or 'Search results for "Foo"'
      page.has_content?("results for \"#{name}\"")
    end

    def parse_results
      begin
        find(".resultsTable")
      rescue Capybara::ElementNotFound => e
        return
      end

      all(".resultsTable tbody tr").inject({}) do |h, tr|
        name      = tr.find("td:first-child").text
        iata_code = tr.find('td:first-child + td').text

        h[name] = iata_code
        h
      end
    end

    def show_rendered(options = { full: true })
      page.save_screenshot("/tmp/capybara.png", options)
      `open /tmp/capybara.png`
    end
  end

  class Scraper
    attr_reader :strategy

    def initialize(configuration = {})
      @strategy = configuration[:strategy] || CapybaraEngine.new
    end

    def scrape(airline_name)
      @strategy.scrape(url, airline_name)
    end

    private

    def url
      "/publications/Pages/code-search.aspx"
    end
  end
end
