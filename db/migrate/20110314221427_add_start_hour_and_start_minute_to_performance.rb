class AddStartHourAndStartMinuteToPerformance < ActiveRecord::Migration
  def self.up
    add_column :performances, :start_hour, :integer
    add_column :performances, :start_minute, :integer
  end

  def self.down
    remove_column :performances, :start_hour
    remove_column :performances, :start_minute
  end
end
