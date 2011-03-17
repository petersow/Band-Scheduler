class CreateEventPersonRoles < ActiveRecord::Migration
  def self.up
    create_table :event_person_roles, :id => false do |t|
      t.column :event_id, :integer
      t.column :person_id, :integer
      t.column :role_id, :integer
    end
  end

  def self.down
    drop_table :event_person_roles
  end
end
