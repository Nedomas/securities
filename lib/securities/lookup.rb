module Securities
	#
	# Symbol lookup with Securities::Lookup.new('apple')
	#
	class Lookup

		attr_accessor :input, :output
		# Error handling
    class LookupException < StandardError ; end

    def initialize parameters
    	@input = parameters
    	if @input.empty?
    		raise LookupException, 'The lookup input was empty.'
    	end
    	url = generate_lookup_url
    	request = :lookup
    	@output = Securities::Scraper.get(request, url)
    end

    private

    	def generate_lookup_url
    		url = 'http://finance.yahoo.com/lookup?s=' + @input
    		return url
    	end
	end

end