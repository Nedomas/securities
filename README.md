# Securities

Financial information scraper and a technical analysis tool.

## Installation

Add this line to your application's Gemfile:

    gem 'securities'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install securities

## Usage

		Usage: Securities::Stock.new('aapl', 'yhoo').history(:start_date => '2012-01-01', :end_date => '2012-02-01', :periods => :weekly)
		:periods accepts :daily, :weekly, :monthly, :dividend. If not specified, it defaults to :daily.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
