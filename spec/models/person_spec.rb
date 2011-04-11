require 'spec_helper'

describe Person do

  it "should create a person with a role" do
    role = Role.create("Guitarist") 

    @person = Person.new(:first_name => "Peter", :last_name => "Sowerbutts",
                         :roles => [role])
    @person.save!

    Person.all.size.eql?(1).should be_true
  end

  it "should create an entry in people_roles" do
    role = Role.create("Guitarist") 

    @person = Person.new(:first_name => "Peter", :last_name => "Sowerbutts",
                         :roles => [role])
    @person.save!
    db = ActiveRecord::Base.connection.instance_variable_get(:@connection)
    result = db.execute "select count(*) from people_roles"
    result[0][0].eql?(1).should be_true
  end

  it "should delete a person" do
    role = Role.create("Guitarist") 

    @person = Person.create(:first_name => "Peter", :last_name => "Sowerbutts",
                         :roles => [role])
    @person.delete
    Person.all.size.eql?(0).should be_true
  end

  it "should delete the entry in people_roles when deleting a person" do
    role = Role.create("Guitarist") 

    @person = Person.create(:first_name => "Peter", :last_name => "Sowerbutts",
                            :roles => [role])
    @person.delete
    db = ActiveRecord::Base.connection.instance_variable_get(:@connection)
    result = db.execute "select count(*) from people_roles"
    result[0][0].eql?(0).should be_true
  end



end
