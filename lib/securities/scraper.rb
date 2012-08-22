require 'active_support/core_ext'
require 'csv'

module Securities
	class Scraper
		def initialize ticker
      url = yahoo_url(ticker, '2012-01-01', '2012-02-02')
      @results = Array.new
      i = 0;
  		CSV.parse(open(url))[1..-1].each do |row|
  				@results[i] = {:date => row[0], :open => row[1], :high => row[2], :low => row[3], :close => row[4], :volume => row[5], :adjClose => row[6]}
  				i += 1
      end
    end

		def yahoo_url(ticker, from, to)
  		'http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=d&ignore=.csv' % [
  		ticker, 
  		from.to_date.month,
  		from.to_date.day,
  		from.to_date.year,
  		to.to_date.month,
  		to.to_date.day,
  		to.to_date.year
  	]
  	end
	end
end