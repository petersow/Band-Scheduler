class PerformanceRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :performance

  def event_instance(event_id)
    EventPersonRole.find(:first, :conditions => ["event_id = ? AND role_id = ?", event_id, self.role_id])
  end

end
