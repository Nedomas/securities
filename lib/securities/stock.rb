module Securities
	#
	# Usage: Securities::Stock.new('aapl', 'yhoo').history(:start_date => '2012-01-01', :end_date => '2012-02-01', :periods => :weekly)
	# :periods accepts :daily, :weekly, :monthly, :dividend. If not specified, it defaults to :daily.
	# 

	class Stock

		attr_reader :symbols, :type
		# REGEX for YYYY-MM-DD
		DATE_REGEX = /^[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])/
		PERIODS_ARRAY = [:daily, :weekly, :montly, :dividends]

		# Error handling
		class StockException < StandardError
		end

		def initialize *parameters
			validate_symbols(parameters)
		end

		def history parameters
			@type = :history
			parameters[:symbols] = @symbols
			# puts parameters
			# puts parameters.class
			validate_history(parameters)
			urls = generate_url(parameters)
			Securities::Scraper.new(@type, urls)
		end

		private
		#
		# Generating URL for various types of requests within stocks.
		#
		# Using Yahoo Finance
		# http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=%s&ignore=.csv
		# 
		# s = ticker symbol.
		#
		# Start date
		# a = start_month
		# b = start_day
		# c = start_year
		#
		# End date
		# d = end_month
		# e = end_day
		# f = end_year
		#
		# g = :periods 
		# Possible values are 'd' for daily (the default), 'w' for weekly, 'm' for monthly and 'v' for dividends.
		#
		def generate_url parameters
			#
			# URL for stock history prices.
			# TODO: Accept type :quote for more detailed info (P/E, P/S, etc.)
			if @type == :history
				@start_date = parameters[:start_date].to_date
				@end_date = parameters[:end_date].to_date

				@periods = case parameters[:periods]
										when :daily 		then 'd'
										when :weekly 		then 'w'
										when :monthly 	then 'm'
										when :dividends then 'v'
									 end

				@results = Hash.new
				@symbols.each do |symbol|
					url = 'http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=%s&ignore=.csv' % [
						symbol,
						@start_date.month - 1,
						@start_date.day,
						@start_date.year,
						@end_date.month - 1,
						@end_date.day,
						@end_date.year,
						@periods
					]
					@results[symbol] = url
				end
				#
				# Returns a hash {'symbol' => 'url'}
				#
				return @results
			else
				raise StockException, 'The type is alien.'
			end

		end 
		#
		# Input parameters validation
		#
		def validate_symbols parameters

			@symbols = parameters.reject(&:empty?)
			unless !@symbols.empty?
				raise StockException, 'You must specify stock symbols.'
			end

			unless @symbols.uniq.length == @symbols.length
				raise StockException, 'Duplicate symbols given.'
			end
		end

		# TODO: Add date validation (like if end_date > start_date).
		def validate_history parameters
			unless parameters.is_a?(Hash)
				raise StockException, 'Given parameters have to be a hash.'
			end

			unless parameters.has_keys?(:start_date, :end_date)
				raise StockException, 'You must specify :start_date and :end_date.'
			end

			unless DATE_REGEX.match(parameters[:start_date])
				raise StockException, 'Invalid :start_date specified. Format YYYY-MM-DD.'
			end

			unless DATE_REGEX.match(parameters[:end_date])
				raise StockException, 'Invalid :end_date specified. Format YYYY-MM-DD.'
			end

			# Set to default :periods if key isn't specified.
			unless parameters.has_key?(:periods)
				parameters[:periods] = :daily
			end

			unless PERIODS_ARRAY.include?(parameters[:periods])
				raise StockException, 'Invalid :periods value specified.'
			end
		end

	end
end

#
# The missing hash function
# Returns true if all keys are present in hash.
#
class Hash
	def has_keys?(*_keys)
  	(_keys - self.keys).empty?
	end
end