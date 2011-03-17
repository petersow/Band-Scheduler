class Event < ActiveRecord::Base
  has_many :event_person_roles, :dependent => :delete_all
end
