require 'active_support'
require 'active_support/core_ext'
require 'uri'
require 'net/http'
require 'csv'
require 'nokogiri'

module Securities
  #
  # Main class to communicate with Yahoo! Finance
  #
	class Scraper

    # Error handling
    class ScraperException < StandardError ; end

    def self.get type, url
      results = Array.new
      
      # Encoding for bad characters in index names.
      clean_url = URI::encode(url)
      uri = URI.parse(clean_url)

      # Check connection.
      begin
        get = Net::HTTP.get(uri)
      rescue => error
        raise ScraperException, "Connection error: #{error.message}"
      end

      case type
      #
      # Scraping for lookup.
      when :lookup
        doc = Nokogiri::HTML(get)

        table = doc.at('div#yfi_sym_results tbody')

        if table.nil?
          raise ScraperException, 'There were no results for this lookup.'
        end

        # Symbol  Name  Last Trade  Type  Industry/Category Exchange
        table.xpath('tr').each do |tr|
          row = tr.xpath('td')
          results << {:symbol => row[0].text,
                      :name => row[1].text, 
                      :last_trade => row[2].text, 
                      :type => row[3].text, 
                      :industry_category => row[4].text, 
                      :exchange => row[5].text}
        end
      #
      # Scraping for history
      when :history
        # Skip first line because it contains headers with Date,Open,High,Low,Close,Volume,Adj Close.
        # Check for errors during CSV parsing.
        begin
          csv = CSV.parse(get, :headers => true)
        rescue => error
          # Probably an invalid symbol specified or there was some other way the parser couldn't read a CSV.
          raise ScraperException, 'Stock symbol does not exist.'
        end

        csv.each_with_index do |row, index|
          line = Hash.new
          csv.headers.each_with_index do |header, i|
            # Set headers as keys for the data hash.
            line[header.parameterize.underscore.to_sym] = row[i]
            results[index] = line
          end
        end

        if results.empty?
          raise ScraperException, 'There were no results for this symbol.'
        end

        # Reversing results to return from the oldest to the newest.
        results = results.reverse
      end

      return results
    end

	end
end