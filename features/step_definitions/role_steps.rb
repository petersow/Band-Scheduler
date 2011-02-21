Given /^an empty role table$/ do
  Role.all.should be_empty
end

When /^I create a role (.+)$/ do |role_name|
  @role = Role.create!(:name => role_name)
end

Then /^there should be exactly (\d+) role with the name (.+)$/ do |total, role_name|
  Role.all.size.should == total.to_i
  Role.first.name.should == role_name
end

When /^via the web I create a role (.+)$/ do |role_name|
  visit roles_index_path
  click_link "Add Role"
  fill_in "Name", :with => role_name
  click_button "Save"
end

Then /^there should be exactly 2 roles, 1 with the name (.+) and 1 with the name (.+)$/ do |first_role, second_role|
  visit roles_index_path
  response.should contain("2 Roles")
  response.should contain(first_role)
  response.should contain(second_role)
end

