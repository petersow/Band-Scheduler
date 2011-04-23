class SchedulerController < ApplicationController

  def default_generate
    generate(Hash.new)
    redirect_to root_path
  end

  def generate(time)
    performances = Performance.all
    if time[:start_date] and time[:end_date]
      @weeks = ((time[:end_date]-time[:start_date])/1.week).to_i
    end
    performances.each do |performance|
      if performance.weekly
        date = time[:start_date]
        @weeks.times do 
          while(date.wday != performance.weekly)
             date = date + 1.day
          end
          performance.one_off = date
          generate_event_from_performance(performance)
          # Essentially mark this day as being "done"
          date = date + 1.day
        end
      else
        generate_event_from_performance(performance)
      end
    end
  end

  def clear
    Event.delete_all
    redirect_to root_path
  end
  def generate_event_from_performance(performance)
    counter = 0
    event = Event.new(:name => performance.name, :performance_id => performance.id)
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
        role_counter = 0
        Person.all.each do |person|
          unless used_people.include?(person) or role_counter >= pr.quantity
            if person.roles.include?(pr.role)

              if pr.role.name = "Lead"
                unless performance.last_event.nil?
                  unless person.eql?(performance.last_event.lead)
                    event.event_person_roles << EventPersonRole.new(:person_id => person.id,
                                                                    :role_id => pr.role.id)
                    used_people << person
                    role_counter = role_counter + 1
                  end
                else
                  event.event_person_roles << EventPersonRole.new(:person_id => person.id,
                                                                  :role_id => pr.role.id)
                  used_people << person
                  role_counter = role_counter + 1
                end
              else
                event.event_person_roles << EventPersonRole.new(:person_id => person.id,
                                                                :role_id => pr.role.id)
                used_people << person
                role_counter = role_counter + 1
              end
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
