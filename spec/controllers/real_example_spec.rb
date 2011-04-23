require 'spec_helper'

describe SchedulerController do

  context "generate event" do

    before(:each) do
      Performance.delete_all
      @@sunday = 0
      @performance = Performance.create(:name => "Sunday Morning", :start_minute => "00", 
                                        :start_hour => "11", :weekly => @@sunday)
    end

    context "1 lead, 1 guitarist" do
 
      before(:each) do
        @lead = Role.create(:name => 'Lead')
        @electric_guitar = Role.create(:name => 'Electric Guitar')

        @performance.performance_roles << PerformanceRole.new(:role_id => @lead.id, 
                                                              :quantity => 1)
        @performance.performance_roles << PerformanceRole.new(:role_id => @electric_guitar.id, 
                                                              :quantity => 1)

        @performance.one_off = nil
        @performance.weekly = 0   

        @performance.save
      end


      context "with 2 people that can do both and generate for 2 weeks" do
        before(:each) do
          @dan = Person.create(:first_name => "Dan", :last_name => "Bailey", 
                               :roles => [@lead, @electric_guitar])
          @mitch = Person.create(:first_name => "Mitch", :last_name => "Lewis",
                                 :roles => [@lead, @electric_guitar])
          controller.generate(:start_date => Time.now, :end_date => Time.now+(2.week))
        end

        it "should create 2 events" do
          Event.all.size.should eql 2

        end

        it "should have a guitarist for both" do
          Event.all.each do |event|
            event.electric_guitar.should_not be_nil
          end  
        end

        it "should have a lead for both" do
          Event.all.each do |event|
            event.lead.should_not be_nil
          end  
        end

        it "shouldn't have 1 person doing both" do
          Event.all.first.lead.id.should_not eq Event.all.first.electric_guitar.id
        end

        it "should rotate the leads" do
          Event.all.first.lead.id.should_not eq Event.all.last.lead.id
        end

        it "should print out the result" do
          puts "\n"
          Event.all.each do |event|
            puts "------------------"
            puts event.start_time
            puts "Lead"
            person = event.lead
            puts "#{person.name} #{person.events_in_a_row(event)}"
            puts "Electric Guitar"
            person = event.electric_guitar
            puts "#{person.name} #{person.events_in_a_row(event)}"
          end
        end
        context "with 3 people that can lead and generate for 3 weeks" do
          before(:each) do
            Event.delete_all
            @keys = Role.create(:name => 'Keys')

            @rachel = Person.create(:first_name => "Rachel", 
                                    :last_name => "???", 
                                    :roles => [@lead, @keys])

            @performance.performance_roles << PerformanceRole.new(:role_id => @keys.id,
                                                                  :quantity => 1)
            @performance.save
            controller.generate(:start_date => Time.now, 
                                :end_date => Time.now+(3.week))
          end

          it "should create 3 events" do
            Event.all.size.should eql 3
          end

          it "should have a guitarist for the first 2" do
            Event.all.first.electric_guitar.should_not be_nil
            Event.all[1].electric_guitar.should_not be_nil
          end

          it "should have a lead for all" do
            Event.all.each do |event|
              event.lead.should_not be_nil
            end  
          end

#        it "shouldn't have 1 person doing both" do
#          Event.all.first.lead.id.should_not eq Event.all.first.electric_guitar.id
#        end

#        it "should rotate the leads" do
#          Event.all.first.lead.id.should_not eq Event.all.last.lead.id
#        end

          it "should print out the result" do
            puts "\n"
            Event.all.each do |event|
              puts "------------------"
              puts event.start_time
              puts "Lead"
              person = event.lead
              if person
                puts "#{person.name} #{person.events_in_a_row(event)}"
              end
              puts "Electric Guitar"
              person = event.electric_guitar
              if person
                puts "#{person.name} #{person.events_in_a_row(event)}"
              end
              puts "Keys"
              person = event.keys
              if person
                puts "#{person.name} #{person.events_in_a_row(event)}"
              end
            end
          end
        end
      end
    end

    context "A big example" do
       before(:each) do
        @lead = Role.create(:name => 'Lead')

        @acoustic_guitar = Role.create(:name => 'Acoustic Guitar')
        @electric_guitar = Role.create(:name => 'Electric Guitar')

        @keys = Role.create(:name => 'Keys')
        @drums = Role.create(:name => 'Drums')
        @bass = Role.create(:name => 'Bass')
        @violin = Role.create(:name => 'Violin')
        @flute = Role.create(:name => 'Flute')
        @trumpet = Role.create(:name => 'Trumpet')
        @cello = Role.create(:name => 'Cello')

        @singer = Role.create(:name => 'Singer')
        @pa = Role.create(:name => 'PA')
        @easy_worship = Role.create(:name => 'Easy Worship')

        @dan = Person.create(:first_name => "Dan", :last_name => "Bailey", :roles => [@lead, @electric_guitar, @easy_worship])
        @mitch = Person.create(:first_name => "Mitch", :last_name => "Lewis", :roles => [@lead, @electric_guitar, @easy_worship])
        @rachel = Person.create(:first_name => "Rachel", :last_name => "???", :roles => [@lead, @keys, @easy_worship])

        @andy_m = Person.create(:first_name => "Andy", :last_name => "M???", :roles => [@electric_guitar, @easy_worship])

        @janie = Person.create(:first_name => "Janie", :last_name => "???", :roles => [@singer, @keys, @easy_worship])
        @richard = Person.create(:first_name => "Richard", :last_name => "???", :roles => [@cello, @keys, @easy_worship])

        @peter = Person.create(:first_name => "Peter", :last_name => "Armstrong", :roles => [@bass, @easy_worship])
        @andrew = Person.create(:first_name => "Andrew", :last_name => "Armstrong", :roles => [@bass, @easy_worship])

        @andy_p = Person.create(:first_name => "Andy", :last_name => "P???", :roles => [@drums, @singer, @easy_worship])
        @neil = Person.create(:first_name => "Neil", :last_name => "???", :roles => [@drums, @easy_worship])

        @lynn = Person.create(:first_name => "Lynn", :last_name => "???", :roles => [@violin, @singer, @easy_worship])
        @stuart = Person.create(:first_name => "Stuart", :last_name => "???", :roles => [@trumpet, @easy_worship])

        @sue = Person.create(:first_name => "Sue", :last_name => "???", :roles => [@singer, @easy_worship])
        @yvonne = Person.create(:first_name => "Yvonne", :last_name => "???", :roles => [@singer])
        @alison = Person.create(:first_name => "Alison", :last_name => "???", :roles => [@singer, @easy_worship])
        @rebekah_p = Person.create(:first_name => "Rebekah", :last_name => "P???", :roles => [@singer, @easy_worship])
        @rebecca_l = Person.create(:first_name => "Rebecca", :last_name => "???", :roles => [@singer, @easy_worship])
        @rebecca_a = Person.create(:first_name => "Rebecca", :last_name => "???", :roles => [@singer, @easy_worship])

        @mark = Person.create(:first_name => "Mark", :last_name => "Harris", :roles => [@pa])
        @joel = Person.create(:first_name => "Joel", :last_name => "_Dunno_", :roles => [@pa])

        @performance.performance_roles << PerformanceRole.new(:role_id => @lead.id, 
                                                              :quantity => 1)
        @performance.performance_roles << PerformanceRole.new(:role_id => @electric_guitar.id, 
                                                              :quantity => 1)
#        @performance.performance_roles << PerformanceRole.new(:role_id => @bassist.id, 
#                                                              :quantity => 1)
#        @performance.performance_roles << PerformanceRole.new(:role_id => @singer.id, 
#                                                              :quantity => 2)
#        @performance.performance_roles << PerformanceRole.new(:role_id => @lead.id, 
#                                                              :quantity => 1)
#        @performance.performance_roles << PerformanceRole.new(:role_id => @computer.id, 
#                                                              :quantity => 1)

        @performance.one_off = nil
        @performance.weekly = 0   

        @performance.save

      end

      it "should create the event" do
        before = Event.all.size
        controller.generate(:start_date => Time.now, :end_date => Time.now+(1.week))
        Event.all.size.should == (before+1)
      end

      it "should create 12 weeks at a time" do
        before = Event.all.size
        controller.generate(:start_date => Time.now, :end_date => Time.now+(12.week))
        last_date = nil
        Event.all.size.should == (before+12)
        last_date = nil
        Event.all.each do |event|
          event.start_time.wday.should == 0
          if last_date
            event.start_time.should_not eql last_date
          end
        end
      end

      context "weekly performances" do

        before(:each) do
          controller.generate(:start_date => Time.now, :end_date => Time.now+(4.week))
        end
 
        it "should take a time parameter" do
        #  controller.generate(:start_date => Time.now, :end_date => Time.now+(1.week))
        end
 
        it "should generate 4 events for a month" do
          Event.all.size.should == 4
          last_date = nil
          Event.all.each do |event|
            event.start_time.wday.should == @@sunday
            if last_date
              event.start_time.should_not eql last_date
            end
            last_date = event.start_time
          end
        end

        it "should rotate the leads each week" do
          last_event = nil
          Event.all.each do |event|
            unless last_event.nil?
              event.lead.should_not eql last_event.lead
            end
            last_event = event
          end
        end

        it "should give people a week off every 3 weeks" do 
          last_event = nil
          Event.all.each do |event|
            EventPersonRole.where(:event_id => event).each do |epr|
              person = Person.find(epr.person_id)
              (person.events_in_a_row(event) >= 2).should_not be_true
            end
          end
        end

        it "should print out the result" do
          puts "\n"
          Event.all.each do |event|
            puts "------------------"
            puts event.start_time
            epr = EventPersonRole.where(:event_id => event.id).each do |epr|
              puts Role.find(epr.role_id).name
              person = Person.find(epr.person_id)
              puts "#{person.name} #{person.events_in_a_row(event)}"
            end
          end
        end

      end
    end
  end
end
