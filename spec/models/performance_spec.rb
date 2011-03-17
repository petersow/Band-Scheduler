require 'spec_helper'

describe Performance do
 
  before(:each) do
    @performance = Performance.new
  end

  it "should have a weekly slot" do
    @performance.weekly = 0
    @performance.save.should be_true
  end

  it "should have a one-off option" do
    @performance.one_off = Date.parse(Time.now.strftime('%Y/%m/%d'))
    @performance.save.should be_true
  end

  it "shouldn't be able to have both a weekly and a one-off" do
    @performance.weekly = 0
    @performance.one_off = Date.parse(Time.now.strftime('%Y/%m/%d'))
    @performance.save.should be_false
  end

  it "should have a start hour" do
    @performance.start_hour = 12
    @performance.save.should be_true
  end

  it "shouldn't allow a start hour below 0" do
    @performance.start_hour = -1
    @performance.save.should be_false
  end

  it "shouldn't allow a start hour above 23" do
    @performance.start_hour = 24
    @performance.save.should be_false
  end
  
  it "should have a start minute" do
    @performance.start_minute = 0
    @performance.save.should be_true
  end

  it "shouldn't allow a start minute below 0" do
    @performance.start_minute = -1
    @performance.save.should be_false
  end

  it "shouldn't allow a start minute above 59" do
    @performance.start_hour = 60
    @performance.save.should be_false
  end
end
