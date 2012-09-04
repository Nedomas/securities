require 'spec_helper'

describe Securities::Stock do
	describe ".new" do
    
    it "should raise error when no parameter is passed" do
      expect { Securities::Stock.new }.should raise_error
    end
    
  end
end