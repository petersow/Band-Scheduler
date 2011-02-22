class PerformanceRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :performance
end
