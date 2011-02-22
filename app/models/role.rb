class Role < ActiveRecord::Base
  has_and_belongs_to_many :people

  has_many :performance_roles, :dependent => :delete_all
  has_many :performances, :through => :performance_roles

end
