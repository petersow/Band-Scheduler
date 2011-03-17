class EventPersonRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :person
  belongs_to :event
end
