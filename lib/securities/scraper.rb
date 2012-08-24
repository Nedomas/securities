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
      # Scrape
    end

	end
end