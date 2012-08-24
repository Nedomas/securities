require 'active_support/core_ext'
require 'uri'
require 'net/http'
require 'csv'

module Securities
  #
  # Main class to communicate with Yahoo! Finance
  #
	class Scraper

    attr_reader :results
    # Error handling
    class ScraperException < StandardError
    end

    def initialize type, parameters
      @results = Hash.new

      # Manage different type requests.
      case type
        when :history then @results = scrape_history(parameters)
        else raise ScraperException, 'Cannot determine request type.'
      end
    end

    def scrape_history parameters
      parameters.each do |symbol, url|

        uri = URI.parse(url)

        # Check connection
        begin
          get = Net::HTTP.get(uri)
        rescue => error
          raise ScraperException, "Connection error: #{error.message}"
        end

        # Skip first line because it contains headers with Date,Open,High,Low,Close,Volume,Adj Close
        csv = CSV.parse(get, :headers => true)

        data = Array.new
        csv.each_with_index {|row, index|
          data[index] = {:date => row[0], :open => row[1], :high => row[2], :low => row[3], :close => row[4], :volume => row[5], :adj_close => row[6]}
        }
        @results[symbol] = data 
      end
      return @results
    end

	end
end