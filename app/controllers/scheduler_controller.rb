class SchedulerController < ApplicationController

  def generate
    performances = Performance.all
    people = Person.all
    used_people_ids = []
    performances.each do |performance|
      generate_event_from_performance(performance)
    end
    redirect_to root_path
  end

  def generate_event_from_performance(performance)
    counter = 0
    event = Event.new(:name => performance.name)
    used_people = []
 
    if performance.one_off
      event.start_time = Time.gm(performance.one_off.year, 
                                 performance.one_off.month,
                                 performance.one_off.day,
                                 performance.start_hour,
                                 performance.start_minute)
    end
    performance.performance_roles.each do |pr|
      counter = counter + pr.quantity
      pr.quantity.times do
        Person.all.each do |person|
          unless used_people.include?(person) or event.event_person_roles.size.eql?(pr.quantity)
            if person.roles.include?(pr.role)
              event.event_person_roles << EventPersonRole.new(:person_id => person.id,
                                                              :role_id => pr.role.id)
              used_people << person
            end
          end
        end
      end
    end

    if counter.eql?(event.event_person_roles.size)
      event.save
      return event
    else
      return nil
    end
  end

end
