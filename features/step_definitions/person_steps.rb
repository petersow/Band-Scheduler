Given /^a role named (.+)$/ do |role_name|
  @role = Role.create!(:name => role_name)
end

When /^I create a person Dan Bailey with a role of Guitarist$/ do
  @person = Person.create!(:first_name => "Dan", :last_name => "Bailey")
  @person.roles << @role 
end

Then /^Dan Sowerbutts should be listed in the (.+) role$/ do |role_name|
  @role_2 = Role.find_by_name(role_name)
  @role_2.people.any? do |person|
    person.id.should == @person.id
  end
end

When /^I create a person Dave Grohl and select a role of Drummer$/ do
  visit people_index_path
  click_link "Add Person"
  fill_in "First Name", :with => "Dave"
  fill_in "Last Name", :with => "Grohl"
  check "Drummer"
  click_button "Save"
end

Then /^Dave Grohl should be listed as a Drummer in the summary table$/ do
  visit people_index_path
  response.should contain("1 Person")
  response.should contain("Dave Grohl")
  response.should contain("Drummer")
end
