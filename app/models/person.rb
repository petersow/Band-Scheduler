class Person < ActiveRecord::Base
  has_and_belongs_to_many :roles, :delete_sql =>
    'DELETE FROM people_roles where person_id = #{id}'

  def name
    "#{self.first_name} #{self.last_name}"
  end
end
