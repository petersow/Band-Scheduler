class AddDateToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :start_time, :datetime
  end

  def self.down
    remove_column :events, :start_time
  end
end
