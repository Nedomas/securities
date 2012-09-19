# Securities

Financial information scraper gem. 
Uses Yahoo Finance API. Current functionality demo of this gem, working in synergy with gem ta: http://strangemuseum.heroku.com

[![Build Status](https://secure.travis-ci.org/Nedomas/securities.png)](http://travis-ci.org/Nedomas/securities)[![Build Status](https://gemnasium.com/Nedomas/securities.png)](https://gemnasium.com/Nedomas/securities)

## Installation

Add this line to your application's Gemfile:

    gem 'securities'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install securities

## Usage

You can get stock information with commands:

	my_stocks = Securities::Stock.new(:symbol => 'AAPL', :start_date => '2012-01-01', :end_date => '2012-02-01', :type => :weekly)
	
	Optional parameter :type accepts :daily, :weekly, :monthly, :dividend. If not specified, it defaults to :daily.

	:end_date defaults to Date.today if not specified.

You can access hash for a single stock with:

	my_stocks.output
	my_stocks.symbol
	my_stocks.start_date
	my_stocks.end_date
	my_stocks.type

Output is returned in a hash:

		[{:date=>"2012-01-03", 
		:open=>"409.40", 
		:high=>"412.50", 
		:low=>"409.00", 
		:close=>"411.23", 
		:volume=>"10793600", 
		:adj_close=>"409.47"}, 
		{:date=>"2012-01-04",
		:open=>"410.00",
		:high=>"414.68", 
		:low=>"409.28", 
		:close=>"413.44", 
		:volume=>"9286500", 
		:adj_close=>"411.67"}]

Stock symbol lookup:
	
	my_lookup = Securities::Lookup.new('Google')

Returns a hash with matched symbol, name, last trade, type, industry/category, exchange.

	my_lookup.output

		[{:symbol=>"GOOG",
		 :name=>"Google Inc.",
		 :last_trade=>"726.31",
		 :type=>"Stock", 
		 :industry_category=>"Internet Information Providers", 
		 :exchange=>"NMS"}, 
		 {:symbol=>"GOOG.MX", 
		 :name=>"Google Inc.", 
		 :last_trade=>"9,306.00", 
		 :type=>"Stock", 
		 :industry_category=>"Internet Information Providers", 
		 :exchange=>"MEX"}, 
		 ...]

	 my_lookup.input returns 'Google'

# Version 2.0.0

* Adds support for stock symbol lookup.

* Removes support for multiple stock input cause it complects the gem code and its implementation without adding much to it. 

## To do:

* Add quote info (P/E, P/S, etc.)
* Add options support.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
