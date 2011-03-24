require 'spec_helper'

describe "people/new.html.haml" do

  before(:each) do
    @person = Person.new
    @roles = Array.new
    render
  end

  context "new people form" do
    before(:each) do
      rendered.should have_selector("form", :id => "new_person") do |form|
        @form = form
      end
    end

    it "should have a form" do
      @form.should_not be_nil
    end

    it "should have a first name field" do
      @form.should have_selector("input", :id => "person_first_name")
    end

    it "should have a last name field" do
      @form.should have_selector("input", :id => "person_last_name")
    end

    it "should have no role checkboxes" do
      @form.should_not have_selector("input", :id => "roles_", :type => "checkbox")
    end

    context "with 1 Guitarist" do
      before(:each) do
        @guitarist = Role.create(:name => "Guitarist")
        @roles = Role.all
        render
        rendered.should have_selector("form", :id => "new_person") do |form|
          @form = form
        end
      end

      it "should have a guitarist checkbox" do
        @form.should have_selector("input", :id => "roles_", :type => "checkbox", :value => @guitarist.id.to_s)
      end
    end
  end
end

