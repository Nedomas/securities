require 'spec_helper'

describe Securities::Stock do
	describe ".new" do

		context "should raise an exception if parameter" do
    
	    it "is not passed" do
	      expect { Securities::Stock.new('') }.to raise_error
	    end
	    it "is not a string" do
	      expect { Securities::Stock.new(["AAPL", "GOOG"]) }.to raise_error('Stock symbol must be a string.')
	    end
	    it "is an invalid string" do
	      expect { Securities::Stock.new("AAPL company") }.to raise_error('Invalid stock symbol specified.')
	    end

	  end

	  context "should not raise an exception if parameter" do

	    it "is a string" do
	      expect { Securities::Stock.new('AAPL') }.not_to raise_error
	    end

	  end

  end

  describe ".history" do
  	before :all do
  		@my_stocks = Securities::Stock.new('AAPL')
  	end

  	context "should raise an exception if parameter" do

	    it "is a not a hash" do
	      expect { @my_stocks.history('some values') }.to raise_error('Given parameters have to be a hash.')
	    end
	    it ":start_date not specified" do
	    	expect { @my_stocks.history(:end_date => '2012-01-01', :type => :weekly) }.to raise_error('Start date must be specified.')
	  	end
	  	it ":start_date or :end_date is invalid" do
	  		expect { @my_stocks.history(:start_date => '2012-01-50', :end_date => '2012-02-10', :type => :weekly) }.to raise_error('Invalid start date specified. Format YYYY-MM-DD.')
	  		expect { @my_stocks.history(:start_date => '2012-01-10', :end_date => '2012-02-50', :type => :weekly) }.to raise_error('Invalid end date specified. Format YYYY-MM-DD.')
	  	end
	  	it ":start_date greater than :end_date" do
	  		expect { @my_stocks.history(:start_date => '2012-01-10', :end_date => '2012-01-01', :type => :weekly) }.to raise_error('End date must be greater than the start date.')
	  	end
	  	it ":start_date is in the future" do
	  		expect { @my_stocks.history(:start_date => (Date.today+1).strftime("%Y-%m-%d"), :type => :weekly) }.to raise_error('End date must be greater than the start date.')
	  	end
	  	it ":type value is invalid" do
	  		expect { @my_stocks.history(:start_date => '2012-01-01', :type => :some_invalid_value) }.to raise_error('Invalid type specified.')
	  	end

	  end

	  context "should not raise an exception if parameter" do

	    it ":end_date is not specified (should default to today)" do
	      expect { @my_stocks.history(:start_date => '2012-01-01', :type => :weekly) }.not_to raise_error
	      @my_stocks.end_date.to_date.should eq(Date.today)
	    end
	    it ":type is not specified (defaults to :daily)" do
	    	expect { @my_stocks.history(:start_date => '2012-01-01') }.not_to raise_error
	    	@my_stocks.type.should eq(:daily)
	    end

	  end

  end

  describe "Scraper" do
  	context "should raise an exception if" do

  		it "symbol is invalid" do
	      expect { Securities::Stock.new('invalidsymbol').history(:start_date => '2012-01-01', :type => :weekly) }.to raise_error('Stock symbol does not exist.')
	    end
	    it "there are no results" do
	      expect { Securities::Stock.new('AAPL').history(:start_date => '2012-08-01', :end_date => '2012-08-05', :type => :dividends) }.to raise_error('There were no results for this symbol.')
	    end

  	end
  end
end