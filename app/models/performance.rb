class Performance < ActiveRecord::Base
  has_many :performance_roles, :dependent => :delete_all
  has_many :roles, :through => :performance_roles

 #validates_presence_of :name

  validates_numericality_of :start_minute, :on => :create, :allow_nil => true,
                            :greater_than_or_equal_to => 0, :less_than => 60

  validates_numericality_of :start_hour, :on => :create, :allow_nil => true,
                            :greater_than_or_equal_to => 0, :less_than => 24

  class WeeklyValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if record.weekly and record.one_off
        record.errors[attribute] << "can't be specified if one off is"
      end
    end
  end

  validates :weekly, :weekly => true

end
