class AddOptionalToPerformanceRoles < ActiveRecord::Migration
  def self.up
    add_column :performance_roles, :optional, :boolean, :default => false
  end

  def self.down
    remove_column :performance_roles, :optional
  end
end
