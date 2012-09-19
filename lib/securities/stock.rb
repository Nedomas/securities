module Securities

	class Stock

		attr_accessor :symbol, :output, :start_date, :end_date, :type
		# REGEX for YYYY-MM-DD
		DATE_REGEX = /^[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])/
		TYPE_CODES_ARRAY = {:daily => 'd', :weekly => 'w', :monthly => 'm', :dividends => 'v'}

		# Error handling
		class StockException < StandardError ; end

		def initialize parameters
			validate_input(parameters)
			@symbol = parameters[:symbol]
			@start_date = parameters[:start_date]
			@end_date = parameters[:end_date]
			@type = parameters[:type]
			url = generate_history_url
			request = :history
			@output = Securities::Scraper.get(request, url)
		end

		private

			#
			# History URL generator
			#
			# Generating URL for various types of requests within stocks.
			#
			# Using Yahoo Finance
			# http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=%s&ignore=.csv
			# 
			# s = stock symbol
			#
			# Period start date
			# a = start month
			# b = start day
			# c = start year
			#
			# Period end date
			# d = end month
			# e = end day
			# f = end year
			#
			# g = type
			# Type values allowed: 'd' for daily (the default), 'w' for weekly, 'm' for monthly and 'v' for dividends.
			def generate_history_url

				url = 'http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=%s&ignore=.csv' % [
					@symbol,
					@start_date.to_date.month - 1,
					@start_date.to_date.day,
					@start_date.to_date.year,
					@end_date.to_date.month - 1,
					@end_date.to_date.day,
					@end_date.to_date.year,
					TYPE_CODES_ARRAY[@type]
				]

				return url
			end

			#
			# Input parameters validation
			#

			def validate_input parameters
				unless parameters.is_a?(Hash)
					raise StockException, 'Given parameters have to be a hash.'
				end

				# Check if stock symbol is specified.
				unless parameters.has_key?(:symbol)
					raise StockException, 'No stock symbol specified.'
				end
				# Check if stock symbol is a string.
				unless parameters[:symbol].is_a?(String)
					raise StockException, 'Stock symbol must be a string.'
				end
				# Check if stock symbol is valid.
				unless parameters[:symbol].match('^[a-zA-Z0-9]+$')
					raise StockException, 'Invalid stock symbol specified.'
				end

				# Use today date if :end_date is not specified.
				unless parameters.has_key?(:end_date)
					parameters[:end_date] = Date.today.strftime("%Y-%m-%d")
				end

				unless parameters.has_key?(:start_date)
					raise StockException, 'Start date must be specified.'
				end
	 			
				unless DATE_REGEX.match(parameters[:start_date])
					raise StockException, 'Invalid start date specified. Format YYYY-MM-DD.'
				end

				unless DATE_REGEX.match(parameters[:end_date])
					raise StockException, 'Invalid end date specified. Format YYYY-MM-DD.'
				end

				unless parameters[:start_date].to_date < parameters[:end_date].to_date
					raise StockException, 'End date must be greater than the start date.'
				end

				unless parameters[:start_date].to_date < Date.today
					raise StockException, 'Start date must not be in the future.'
				end

				# Set to default :type if key isn't specified.
				parameters[:type] = :daily if !parameters.has_key?(:type)

				unless TYPE_CODES_ARRAY.has_key?(parameters[:type])
					raise StockException, 'Invalid type specified.'
				end
			end

	end
end