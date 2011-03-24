require 'spec_helper'

describe "performances/new.html.haml" do

  before(:each) do
    @performance = Performance.new
    @roles = Array.new
    render
  end 

  context "new performance form" do
    before(:each) do
      rendered.should have_selector("form", :id => "new_performance") do |form|
        @form = form
      end
    end

    it "should have a form" do
      @form.should_not be_nil
    end

    it "should have a name field" do
      @form.should have_selector("input", :id => "performance_name")
    end

    it "should have a start hour field" do
      @form.should have_selector("select", :id => "performance_start_hour")
    end

    it "should have a start minute field" do
      @form.should have_selector("select", :id => "performance_start_minute")
    end
  end

end
