
Given /^a Person named (.+) (.+) with a Role of (.+)$/ do |first_name, last_name, role_name|
  @role = Role.find_by_name(role_name)
  @person = Person.new(:first_name => first_name, :last_name => last_name)
  @person.roles << @role
  @person.save
end

Given /^a Performance with (\d+) (.+)/ do |number_of, role_name|
  @role = Role.find_by_name(role_name)
  @performance = Performance.create(:one_off => Date.parse(Time.now.strftime('%Y/%m/%d')),
                                    :start_hour => 12,
                                    :start_minute => 30)
  PerformanceRole.create(:role_id => @role.id,
                         :performance_id => @performance.id,
                         :quantity => number_of)
end

When /^I fire off the scheduler generator$/ do
  visit root_path
  click_link "Generate Schedule"
end

Then /^there should be an Event with (.+) (.+) filling the (.+) role for the Performance$/ do |first_name, last_name, role_name|
  visit root_path
  response.should contain("1 Event")
  response.should contain(first_name)
  response.should contain(last_name)
  response.should contain(role_name)
end

