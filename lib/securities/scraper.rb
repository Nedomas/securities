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
        # Check for errors during CSV parsing.
        begin
          csv = CSV.parse(get, :headers => true)
        rescue => error
          # PROBABLY an invalid symbol specified or there was some other way the parser couldn't read a CSV.
          raise ScraperException, "Invalid symbols specified."
        end

        data = Array.new
        csv.each_with_index do |row, index|
          line = Hash.new
          csv.headers.each_with_index do |header, i|
            # Set headers as keys for data hash.
            line[header.parameterize.underscore.to_sym] = row[i]
            data[index] = line
          end
        end

        if data.empty?
          raise ScraperException, 'There were no results for these parameters.'
        end

        @results[symbol] = data 
      end
      return @results
    end

	end
end