require 'spec_helper'

describe SchedulerController do

  context "generate event" do

    before(:each) do
      Performance.delete_all
      @performance = Performance.create(:name => "test", :start_minute => "00", :start_hour => "11",
                                        :one_off => Date.parse(Time.now.strftime('%Y/%m/%d')))
    end

    it "should create an event" do
      event = controller.generate_event_from_performance(@performance)
      event.should_not be_nil
      event.instance_of?(Event).should be_true
    end

    it "should set the event name" do
      event = controller.generate_event_from_performance(@performance)
      event.name.should_not be_nil
    end

    it "should set the event's performance" do
      event = controller.generate_event_from_performance(@performance)
      event.performance_id.should_not be_nil
    end

    it "should set the event start time" do
      now = Time.now
      @performance.one_off = Date.parse(now.strftime('%Y/%m/%d'))
      @performance.start_hour = 12
      @performance.start_minute = 30
      event = controller.generate_event_from_performance(@performance)
      event.start_time.year.should be now.year
      event.start_time.month.should be now.month
      event.start_time.day.should be now.day
      event.start_time.min.should be 30
      event.start_time.hour.should be 12
    end

    context "with 1 guitarist" do
      before(:each) do
        @role = Role.create(:name => 'Guitarist')
 
        @person = Person.new(:first_name => "Dan", :last_name => "Smith")
        @person.roles << @role
        @person.save
      end
  
      it "should create an Event for a Performance with 1 Guitarist" do
        @pr = PerformanceRole.create(:role_id => @role.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 1)

        event = controller.generate_event_from_performance(@performance)
        event.event_person_roles.size.should be 1
        event.event_person_roles.each do |epr|
          epr.person.should eql @person
        end
      end

      it "shouldn't create an Event for a Performance with 2 Guitarists" do
        @pr = PerformanceRole.create(:role_id => @role.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 2)
        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.should == before
      end
   
      it "shouldn't create an Event for a Performance with 1 Drummer" do
        @drummer = Role.create(:name => 'Guitarist')
        @pr = PerformanceRole.create(:role_id => @drummer.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 1)
        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.should == before
      end
    end

    context "with 2 guitarist" do
      before(:each) do
        @role = Role.create(:name => 'Guitarist')
 
        @person = Person.new(:first_name => "Dan", :last_name => "Smith")
        @person.roles << @role
        @person.save

        @person = Person.new(:first_name => "James", :last_name => "Jackson")
        @person.roles << @role
        @person.save
      end

      it "should create an Event for a Performance with 2 Guitarists" do
        @performance.performance_roles << PerformanceRole.new(:role_id => @role.id, 
                                                              :quantity => 2)
        @performance.save
        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.should == (before+1)
        event.event_person_roles.first.person_id.should_not == (event.event_person_roles.last.person_id)
      end

      it "should create an Event for a Performance with 1 Guitarist" do
        @pr = PerformanceRole.create(:role_id => @role.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 1)

        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.should == (before+1)
      end
    end

    context "with 1 person whose a drummer and a guitarist" do
       before(:each) do
        @guitarist = Role.create(:name => 'Guitarist')
        @drummer = Role.create(:name => 'Drummer')
 
        @person = Person.new(:first_name => "Jamie", :last_name => "Fluffson")
        @person.roles << @guitarist
        @person.roles << @drummer
        @person.save
      end

      it "should create an Event for a Performance with 1 Guitarist" do
        @pr = PerformanceRole.create(:role_id => @guitarist.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 1)

        @expected_increase = 1
      end

      it "should create an Event for a Performance with 1 Drummer" do
        @pr = PerformanceRole.create(:role_id => @drummer.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 1)

        @expected_increase = 1
      end

      it "shouldn't create an Event for a Performance with 1 Drummer" do
        @performance.performance_roles << PerformanceRole.new(:role_id => @drummer.id, 
                                                              :quantity => 1)
        @performance.performance_roles << PerformanceRole.new(:role_id => @guitarist.id, 
                                                              :quantity => 1)
        @performance.save
        @expected_increase = 0
      end

      after(:each) do
        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.should == (before+@expected_increase)
      end
    end

    # This example didnt work on the browser, so I made it into a test case.
    context "The Beatles have a gig!" do
      before(:each) do
        @guitarist = Role.create(:name => 'Guitarist')
        @drummer = Role.create(:name => 'Drummer')
        @bassist = Role.create(:name => 'Bassist')
        @lead = Role.create(:name => 'Lead')

        Person.create(:first_name => "John", :last_name => "Lennon", :roles => [@lead])
        Person.create(:first_name => "George", :last_name => "Harrison", :roles => [@guitarist])
        Person.create(:first_name => "Paul", :last_name => "McCartney", :roles => [@bassist])
        Person.create(:first_name => "Ringo", :last_name => "Starr", :roles => [@drummer])


        @gig = Performance.create(:name => "Gig", :start_hour => 20,
                                  :start_minute => 00, :one_off => Date.parse("2020-03-03"))

        @gig.performance_roles << PerformanceRole.new(:role_id => @guitarist.id, 
                                                      :quantity => 1)
        @gig.performance_roles << PerformanceRole.new(:role_id => @drummer.id, 
                                                      :quantity => 1)
        @gig.performance_roles << PerformanceRole.new(:role_id => @bassist.id, 
                                                      :quantity => 1)
        @gig.performance_roles << PerformanceRole.new(:role_id => @lead.id, 
                                                      :quantity => 1)
        @gig.save
      end

      it "should create the event" do
        before = Event.all.size
        event = controller.generate_event_from_performance(@gig)
        Event.all.size.should == (before+1)
      end


    end

    context "A big example" do
       before(:each) do
        @guitarist = Role.create(:name => 'Guitarist')
        @drummer = Role.create(:name => 'Drummer')
        @bassist = Role.create(:name => 'Bassist')
        @singer = Role.create(:name => 'Singer')
        @lead = Role.create(:name => 'Lead')
        @computer = Role.create(:name => 'Computer')

        @dan = Person.create(:first_name => "Dan", :last_name => "Bailey", :roles => [@lead])
        @mitch = Person.create(:first_name => "Mitch", :last_name => "Thingy", :roles => [@guitarist])
        @peter = Person.create(:first_name => "Peter", :last_name => "Thingy", :roles => [@guitarist])
        @steve = Person.create(:first_name => "Steve", :last_name => "Bassy", :roles => [@bassist])
        @alex = Person.create(:first_name => "Alex", :last_name => "White", :roles => [@drummer])
        @fi = Person.create(:first_name => "Fi", :last_name => "Bailey", :roles => [@computer])
        @jane = Person.create(:first_name => "Jane", :last_name => "Singer", :roles => [@singer])
        @frank = Person.create(:first_name => "Frank", :last_name => "Holla", :roles => [@singer])

        @performance.performance_roles << PerformanceRole.new(:role_id => @guitarist.id, 
                                                              :quantity => 2)
        @performance.performance_roles << PerformanceRole.new(:role_id => @drummer.id, 
                                                              :quantity => 1)
        @performance.performance_roles << PerformanceRole.new(:role_id => @bassist.id, 
                                                              :quantity => 1)
        @performance.performance_roles << PerformanceRole.new(:role_id => @singer.id, 
                                                              :quantity => 2)
        @performance.performance_roles << PerformanceRole.new(:role_id => @lead.id, 
                                                              :quantity => 1)
        @performance.performance_roles << PerformanceRole.new(:role_id => @computer.id, 
                                                              :quantity => 1)

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
    end

    context "weekly performances" do
 
      it "it should take a time parameter" do
        controller.generate(:start_date => Time.now, :end_date => Time.now+(1.week))
      end

      context "with 1 guitarist and once a week on a monday" do
  
        before(:each) do
          role = Role.create("Guitarist")
          person = Person.create(:first_name => "Dan", :last_name => "Bailey", :roles => [role])
          Performance.delete_all
          performance = Performance.new(:name => "Gig", :start_hour => 20,
                                        :start_minute => 00, :weekly => 1)

          performance.performance_roles << PerformanceRole.new(:role_id => role.id, 
                                                               :quantity => 1)
          performance.save
        end 

        it "it should generate 1 event for a week" do
          controller.generate(:start_date => Time.now, :end_date => Time.now+(1.week))
          Event.all.size.should == 1
          Event.first.start_time.wday.should == 1
        end

        it "it should generate 4 events for a month" do
          controller.generate(:start_date => Time.now, :end_date => Time.now+(4.week))
          Event.all.size.should == 4
          last_date = nil
          Event.all.each do |event|
            event.start_time.wday.should == 1
            if last_date
              event.start_time.should_not eql last_date
            end
            last_date = event.start_time
          end
        end
      end

    end
  end

end
