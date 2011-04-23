class Person < ActiveRecord::Base
  has_and_belongs_to_many :roles, :delete_sql =>
    'DELETE FROM people_roles where person_id = #{id}'

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def events_in_a_row(event)
    size = 100
    result = 0
    while(size != 0)
      event = event.previous_event
      unless event.nil?
        eprs = EventPersonRole.where(:event_id => event.id, :person_id => self.id)
        result = result + eprs.size
        size = eprs.size
      else
        size = 0
      end
    end
    result
  end
end
