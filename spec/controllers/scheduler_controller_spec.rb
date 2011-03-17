require 'spec_helper'

describe SchedulerController do

  context "generate event" do

    before(:each) do
      @performance = Performance.create
    end

    it "should create an event" do
      event = controller.generate_event_from_performance(@performance)
      event.should_not be_nil
      event.instance_of?(Event).should be_true
    end

    it "should set the event start time" do
      now = Time.now
      @performance.one_off = Date.parse(now.strftime('%Y/%m/%d'))
      @performance.start_hour = 12
      @performance.start_minute = 30
      event = controller.generate_event_from_performance(@performance)
      event.start_time.year.eql?(now.year).should be_true
      event.start_time.month.eql?(now.month).should be_true
      event.start_time.day.eql?(now.day).should be_true
      event.start_time.min.eql?(30).should be_true
      event.start_time.hour.eql?(12).should be_true
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
        event.event_person_roles.size.eql?(1).should be_true
        event.event_person_roles.each do |epr|
          epr.person.eql?(@person).should be_true
        end
      end

      it "shouldn't create an Event for a Performance with 2 Guitarists" do
        @pr = PerformanceRole.create(:role_id => @role.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 2)
        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.eql?(before).should be_true
      end
   
      it "shouldn't create an Event for a Performance with 1 Drummer" do
        @drummer = Role.create(:name => 'Guitarist')
        @pr = PerformanceRole.create(:role_id => @drummer.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 1)
        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.eql?(before).should be_true
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
        Event.all.size.eql?(before+1).should be_true
        event.event_person_roles.first.person_id.eql?(event.event_person_roles.last.person_id).should_not be_true
      end

      it "should create an Event for a Performance with 1 Guitarist" do
        @pr = PerformanceRole.create(:role_id => @role.id, 
                                     :performance_id => @performance.id,
                                     :quantity => 1)

        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.eql?(before+1).should be_true
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
        Event.all.size.eql?(before+@expected_increase).should be_true
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
        @frane = Person.create(:first_name => "Frank", :last_name => "Holla", :roles => [@singer])

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
        @performance.save

      end

      it "should create the event" do
        before = Event.all.size
        event = controller.generate_event_from_performance(@performance)
        Event.all.size.eql?(before+1).should be_true
      end

    end
  end

end
