require 'active_record'
require 'active_record/fixtures'

namespace :db do
  DATA_DIRECTORY = "#{::Rails.root.to_s}/lib/tasks/sample_data"

  namespace :sample_data do
    TABLES = %w(roles people people_roles)
    MIN_ID = 1000

    desc "Load sample data" 
    task :load => :environment do |t|
      class_name = nil
      TABLES.each do |table_name|
        fixture = Fixtures.new(ActiveRecord::Base.connection, 
                               table_name, class_name,
                               File.join(DATA_DIRECTORY, table_name.to_s))
        fixture.insert_fixtures
        puts "Loaded data from #{table_name}.yml"
      end
    end

    desc "Remove sample data" 
    task :delete => :environment do |t|
     Role.delete_all("id >= #{MIN_ID}")
     Person.delete_all("id >= #{MIN_ID}")
    end
  end

end
