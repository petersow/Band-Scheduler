class AddWeeklyAndOneOffToPerformance < ActiveRecord::Migration
  def self.up
    add_column :performances, :weekly, :integer
    add_column :performances, :one_off, :date
  end

  def self.down
    remove_column :performances, :weekly
    remove_column :performances, :one_off
  end
end
