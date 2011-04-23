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

  def performance
    Performance.find(self.performance_id)
  end

  def previous_event
    Event.find(:all, :conditions => ["performance_id = ? AND start_time < ?",self.performance_id, self.start_time]).last
  end

  def method_missing(sym, *arg, &block)
    role = Role.find_by_name(sym.to_s.capitalize)
    epr = EventPersonRole.where(:role_id => role.id, :event_id => self.id)
    if epr.size > 0
      Person.find(epr.first.person_id)
    else
      nil
    end
  end
end
