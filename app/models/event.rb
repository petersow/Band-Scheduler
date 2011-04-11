class Event < ActiveRecord::Base
  has_many :event_person_roles, :dependent => :delete_all

  validates :start_time, :presence => true

  def status
    performance = Performance.find(self.performance_id)
    quantity = 0
    performance.performance_roles.each do |pr|
      quantity += pr.quantity
    end

    if self.event_person_roles.size == quantity
      return "filled"
    else
      return "missing"
    end
  end
end
