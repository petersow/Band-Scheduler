require 'spec_helper'

describe "menu/index.html.haml" do

  context "admin panel" do

    before(:each) do
      render
      rendered.should have_selector("div", :id => "admin") do |div|
        @admin_panel = div
      end
    end
 
    it "should be there" do
      @admin_panel.should_not be_nil
    end

    it "should have a link to people" do
      @admin_panel.should have_selector("a", :href => people_path)
    end

    it "should have a link to roles" do
      @admin_panel.should have_selector("a", :href => roles_path)
    end
  end

end
