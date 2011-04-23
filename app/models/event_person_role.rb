class EventPersonRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :person
  belongs_to :event

  def delete
    connection.delete("DELETE from event_person_roles WHERE person_id = #{self.person_id} 
                                                      AND event_id = #{self.event_id} AND role_id = #{self.role_id}")

  end
end
