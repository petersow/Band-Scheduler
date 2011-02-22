class Performance < ActiveRecord::Base
  has_many :performance_roles, :dependent => :delete_all
  has_many :roles, :through => :performance_roles
end
