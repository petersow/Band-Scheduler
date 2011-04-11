require 'spec_helper'

describe SchedulerController do

  context "generate event" do

    before(:each) do
      Performance.delete_all
      @performance = Performance.create(:name => "test", :start_minute => "00", :start_hour => "11",
                                        :one_off => Date.parse(Time.now.strftime('%Y/%m/%d')))
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

        @singer = Role.create(:name => 'Singer')
        @pa = Role.create(:name => 'PA')
        @easy_worship = Role.create(:name => 'Easy Worship')

        @dan = Person.create(:first_name => "Dan", :last_name => "Bailey", :roles => [@lead, @acoustic_guitar])
        @mitch = Person.create(:first_name => "Mitch", :last_name => "Lewis", :roles => [@lead, @acoustic_guitarist])
        @peter = Person.create(:first_name => "Peter", :last_name => "Thingy", :roles => [@guitarist])
        @steve = Person.create(:first_name => "Steve", :last_name => "Bassy", :roles => [@bassist])
        @alex = Person.create(:first_name => "Alex", :last_name => "White", :roles => [@drummer])
        @fi = Person.create(:first_name => "Fi", :last_name => "Bailey", :roles => [@computer])
        @jane = Person.create(:first_name => "Jane", :last_name => "Singer", :roles => [@singer])
        @frank = Person.create(:first_name => "Frank", :last_name => "Holla", :roles => [@singer])

        @mark = Person.create(:first_name => "Mark", :last_name => "Harris", :roles => [@pa])
        @joel = Person.create(:first_name => "Joel", :last_name => "_Dunno_", :roles => [@pa])



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
