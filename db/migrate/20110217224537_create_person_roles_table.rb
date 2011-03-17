class CreatePersonRolesTable < ActiveRecord::Migration
  def self.up
    create_table :people_roles, :id => false do |t|
      t.column :person_id, :integer
      t.column :role_id, :integer
    end
  end

  def self.down
    drop_table :people_roles
  end
end
