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

    def scrape(url, airline_name_or_code)
      @results ||= query_results(url, airline_name_or_code)
    end

    private

    def query_results(url, term)
      visit(url)

      if is_code?(term)
        choose_search_by_airline_code
        enter_airline_code(term)
      else
        choose_search_by_airline_name
        enter_airline_name(term)
      end

      submit_form
      wait_for_results(term)
      parse_results
    rescue Capybara::ElementNotFound => e
      puts "#{e}"
    end

    def choose_search_by_airline_name
      select("Airline name", from: find(".ajaxForm select")[:id])
    end

    def choose_search_by_airline_code
      select("IATA Airline code", from: find(".ajaxForm select")[:id])
    end

    def enter_airline_name(name)
      fill_in(find(".ajaxForm input[type=text]")[:id], :with => name)
    end
    alias :enter_airline_code :enter_airline_name

    def submit_form
      find(".ajaxForm input[type=submit]").click
    end

    def wait_for_results(term)
      # Either 'No results for "Foo"' or 'Search results for "Foo"'
      page.has_content?("results for \"#{term}\"")
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

    def is_code?(term)
      !!(term =~ /\A[A-Z0-9]{2}\Z/)
    end
  end

  class Scraper
    attr_reader :strategy

    def initialize(configuration = {})
      @strategy = configuration[:strategy] || CapybaraEngine.new
    end

    def scrape(airline_name_or_code)
      @strategy.scrape(url, airline_name_or_code)
    end

    private

    def url
      "/publications/Pages/code-search.aspx"
    end
  end
end
