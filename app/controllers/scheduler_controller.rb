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

    Person.all.each do |person|
      # Do I need a day off?
      if person.events_in_a_row(event) >= 2
        next
      end

      used = false
      # What roles can I fill?
      person.roles.each do |role|
        if used
          next
        end

        if role.name.eql?("Lead")
          unless event.previous_event.nil?
            if event.previous_event.lead.id.eql?(person.id)
              next
            end
          end
        end

        #are these roles needed in the event?
        if performance.roles.include?(role)
          #has this role been filled?
          unless event.event_person_roles.one? { |epr| epr.role_id.eql?(role.id) }
            event.event_person_roles << EventPersonRole.new(:person_id => person.id,
                                                            :role_id => role.id)
            used = true
          end
        end
      end
    end

    event.save

    if event.lead.nil?
      leads = []
      Person.all.each do |person|
        if person.roles.include?(Role.find_by_name("Lead"))
          leads << person
        end
      end

      filled = false

      # 2 events ago
      event_to_check = event.previous_event.previous_event
      leads.each do |lead|

        # check if problem is solved
        if filled
          break
        end

        # not lead in this
        if event_to_check.lead.eql?(lead)
          next
        end

        # and not lead last time
        if event.previous_event.lead.eql?(lead)
          next
        end

        # but are in it
        event_to_check.event_person_roles.each do |epr|
          if epr.person_id.eql?(lead.id)
            epr.delete
            EventPersonRole.create(:person_id => lead.id,
                                   :event_id => event.id,
                                   :role_id => Role.find_by_name("Lead"))
            filled = true
          end
        end
      end 

    end
 
    event
  end

end
