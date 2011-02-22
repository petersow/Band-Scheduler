When /^I create a performance with 1 (.+) and 1 (.+)$/ do |role_one, role_two|
  @performance = Performance.new
  @performance.performance_roles << PerformanceRole.new(:performance_id => @performance.id, 
							:role_id => Role.find_by_name(role_one).id,
							:quantity => 1)
  @performance.performance_roles << PerformanceRole.new(:performance_id => @performance.id, 
							:role_id => Role.find_by_name(role_two).id,
						        :quantity => 1)
  @performance.save
end

Then /^there should be a performance listed with 1 (.+) and 1 (.+)$/ do |role_one, role_two|
  PerformanceRole.all.any? do |role|
    Role.find(role.role_id).name.eql?(role_one) and role.performance_id == @performance.id
  end.should be_true

  PerformanceRole.all.any? do |role|
    Role.find(role.role_id).name.eql?(role_two) and role.performance_id == @performance.id
  end.should be_true
end

