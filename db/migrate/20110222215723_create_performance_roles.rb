class CreatePerformanceRoles < ActiveRecord::Migration
  def self.up
    create_table :performance_roles do |t|
      t.column "role_id", :integer, :null => false
      t.column "performance_id", :integer, :null => false
      t.column "quantity", :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :performance_roles
  end
end
