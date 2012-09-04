require 'active_support/core_ext'
require 'uri'
require 'net/http'
require 'csv'

module Securities
  #
  # Main class to communicate with Yahoo! Finance
  #
	class Scraper

    # Error handling
    class ScraperException < StandardError
    end

    def self.get type, parameters

      # Manage different type requests.
      case type
        when :history then results = scrape_history(parameters)
        else raise ScraperException, 'Cannot determine request type.'
      end

      return results
    end

    def self.scrape_history parameters
      results = Hash.new
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
          # It will no longer raise exception because it causes a bug.
          # bug => if exception occurs in one symbol, it will not give any results for any other.
          # raise ScraperException, "Invalid symbol '#{symbol}' specified."
          results[symbol] = []
          next
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

        # It will no longer raise exception if data is empty, because it causes a 
        # bug => if exception occurs in one symbol, it will not give any results for any other.
        # if data.empty?
        #     raise ScraperException, "There were no results for #{symbol}."
        # end

        results[symbol] = data.reverse
      end
      return results
    end

	end
end