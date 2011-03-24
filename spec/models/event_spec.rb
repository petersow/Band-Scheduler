require 'spec_helper'

describe Event do

  it "should have a start time" do
    Event.create(:start_time => Time.now)
  end

  it "should have a name" do
    Event.create(:name => "Band Practice")
  end

end
