class AddNameToPerformanceAndEvent < ActiveRecord::Migration
  def self.up
    add_column :performances, :name, :string
    add_column :events, :name, :string
  end

  def self.down
    remove_column :performances
    remove_column :events, :name
  end
end
