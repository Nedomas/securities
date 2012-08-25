# Securities

[![Build Status](https://secure.travis-ci.org/Nedomas/securities.png)](http://travis-ci.org/Nedomas/securities)

Financial information scraper gem.

## Installation

Add this line to your application's Gemfile:

    gem 'securities'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install securities

## Usage

You can get stock information with commands:

	my_stocks = Securities::Stock.new('aapl', 'yhoo').history(:start_date => '2012-01-01', 
																														:end_date => '2012-02-01', 
																														:periods => :weekly)
	Optional parameter :periods accepts :daily, :weekly, :monthly, :dividend. If not specified, it defaults to :daily.

You can access hash for a single stock with:

	my_stocks.results["yhoo"]

Results are returned in a hash:

	{"aapl"=>
		[{:date=>"2012-01-04",
			:open=>"410.00",
			:high=>"414.68", 
			:low=>"409.28", 
			:close=>"413.44", 
			:volume=>"9286500", 
			:adj_close=>"411.67"}, 
		 {:date=>"2012-01-03", 
		  :open=>"409.40", 
		  :high=>"412.50", 
		  :low=>"409.00", 
		  :close=>"411.23", 
		  :volume=>"10793600", 
		  :adj_close=>"409.47"}], 
	"yhoo"=>
		[{:date=>"2012-01-04", 
		 :open=>"16.12", 
		 :high=>"16.16", 
		 :low=>"15.74", 
		 :close=>"15.78", 
		 :volume=>"35655300", 
		 :adj_close=>"15.78"}, 
		{:date=>"2012-01-03", 
		 :open=>"16.27", 
		 :high=>"16.39", 
		 :low=>"16.20", 
		 :close=>"16.29", 
		 :volume=>"19708600", 
		 :adj_close=>"16.29"}]}

## To do:

* Write specs.
* Add quote info (P/E, P/S, etc.)
* Add symbol from name lookup.
* Add options support.
* Add technical analysis module (or a seperate gem which works in synergy with this).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
