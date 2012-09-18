module Securities

	class Stock

		attr_accessor :symbol, :output, :start_date, :end_date, :type
		# REGEX for YYYY-MM-DD
		DATE_REGEX = /^[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])/
		TYPES_ARRAY = [:daily, :weekly, :monthly, :dividends]

		# Error handling
		class StockException < StandardError
		end

		def initialize parameter
			@symbol = validate_symbol(parameter)
		end

		def history parameters
			request = :history
			validate_history(parameters)
			parameters[:symbol] = @symbol
			@start_date = parameters[:start_date]
			@end_date = parameters[:end_date]
			@type = parameters[:type]
			urls = generate_history_url
			@output = Securities::Scraper.get(request, urls)
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
		# Start date
		# a = start month
		# b = start day
		# c = start year
		#
		# End date
		# d = end month
		# e = end day
		# f = end year
		#
		# g = :type
		# Type values allowed: 'd' for daily (the default), 'w' for weekly, 'm' for monthly and 'v' for dividends.
		def generate_history_url

			# FIX: Should keep it cleaner.
			type_code = case @type
									when :daily 		then 'd'
									when :weekly 		then 'w'
									when :monthly 	then 'm'
									when :dividends then 'v'
								 end

			url = 'http://ichart.finance.yahoo.com/table.csv?s=%s&a=%s&b=%s&c=%s&d=%s&e=%s&f=%s&g=%s&ignore=.csv' % [
				@symbol,
				@start_date.to_date.month - 1,
				@start_date.to_date.day,
				@start_date.to_date.year,
				@end_date.to_date.month - 1,
				@end_date.to_date.day,
				@end_date.to_date.year,
				type_code
			]

			return url
		end

		#
		# Input parameters validation
		#
		def validate_symbol parameter
			
			# Check if stock symbol is a string.
			unless parameter.is_a?(String)
				raise StockException, 'Stock symbol must be a string.'
			end
			# Check if stock symbol is valid.
			unless parameter.match('^[a-zA-Z0-9]+$')
				raise StockException, 'Invalid stock symbol specified.'
			end

			return parameter

		end

		def validate_history parameters
			unless parameters.is_a?(Hash)
				raise StockException, 'Given parameters have to be a hash.'
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

			unless TYPES_ARRAY.include?(parameters[:type])
				raise StockException, 'Invalid type specified.'
			end
		end

	end
end