require 'service_hub/populate_instruments'

desc 'Find or Create Instruments from Source Data'
namespace :instruments do
  task :populate  => :environment do
    puts 'Populating Instruments collection'
    ServiceHub::PopulateInstruments.new.run
    puts 'Done populating Instruments collection'
  end
end