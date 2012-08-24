require 'active_support/core_ext'
require 'csv'
require 'net/http'
require 'uri'

module Securities
  #
  # Main class to communicate with Yahoo! Finance
  #
	class Scraper

    # Error handling
    class ScraperException < StandardError
    end

    def initialize parameters
      
      @type = parameters[:type]
      @symbol = parameters[:symbol]
      @start_date = parameters[:start_date]
      @end_date = parameters[:end_date]

      # Check if it is called with Stock.new
      # TODO: Fix to check caller class without setting :type.
      case @type
        when :stock   then puts 'get_stock_url'
        when :option  then puts 'get_option_url'
      else
        raise ScraperException, 'Unspecified calling class (:type).'
      end
    end

	end
end