require "securities/version"
require "securities/scraper"

module Securities
  def self.get(ticker)
    Scraper.new(ticker)
  end
end
