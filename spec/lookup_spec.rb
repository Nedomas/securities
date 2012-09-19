require 'spec_helper'

describe Securities::Lookup do
	describe "Lookup" do

		context "should raise an exception if parameter" do
			it "is empty" do
				expect { Securities::Lookup.new(' ') }.to raise_error('The lookup input was empty.')
			end
			it "got no results" do
				expect { Securities::Lookup.new('some invalid lookup string') }.to raise_error('There were no results for this lookup.')
			end
		end

		context "should not raise an exception if parameter" do
			it "is not empty" do
				expect { Securities::Lookup.new('Apple') }.not_to raise_error
			end
		end

	end
end