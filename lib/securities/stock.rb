module Securities
	#
	# Usage: Securities::Stock.new(:symbol => 'AAPL', :start_date => '2012-01-01', :end_date => '2012-02-01', :periods => :weekly)
	# :periods accepts :daily, :weekly, :monthly, :dividend. If not specified, defaults to :daily.
	# 

	class Stock

		# REGEX for YYYY-MM-DD
		DATE_REGEX = /^[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])/
		PERIODS_ARRAY = [:daily, :weekly, :montly, :dividend]

		# Error handling
		class StockException < StandardError
		end

		def initialize parameters
			validate_input(parameters)
			parameters[:type] = :stock
			@result = Securities::Scraper.new(parameters)
		end

		#
		# Input parameters validation
		# TODO: Add date validation (like if end_date > start_date).
		#
		def validate_input parameters
			unless parameters.is_a?(Hash)
				raise StockException, 'Parameters given have to be a hash'
			end

			unless parameters.has_keys?(:symbol, :start_date, :end_date)
				raise StockException, 'You must specify :symbol, :start_date and :end_date'
			end

			unless DATE_REGEX.match(parameters[:start_date])
				raise StockException, 'Specified invalid :start_date'
			end

			unless DATE_REGEX.match(parameters[:end_date])
				raise StockException, 'Specified invalid :end_date'
			end

			unless PERIODS_ARRAY.include?(parameters[:periods])
				raise StockException, 'Invalid :periods value specified'
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