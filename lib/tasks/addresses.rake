require 'rgeo/shapefile'

# TODO: In order to be re-deployable, assets should not be hard coded. Maybe we 
# can pull from a URL
# endpoint = 'https://data.nola.gov/download/div8-5v7i/application/zip'
# puts "Connecting to #{endpoint}\n";
# request = Typhoeus::Request.new(endpoint)
    
namespace :addresses do
  desc "Load data.nola.gov addresses into database"
  task :load => :environment do
    shpfile = "#{Rails.root}/lib/assets/NOLA_Addresses_20120309/NOLA_Addresses_20120309.shp"
    RGeo::Shapefile::Reader.open(shpfile, {:srid => -1}) do |file|
      puts "File contains #{file.num_records} records"
      nums = 1..9
      nums.each do |n|
         record = file.get(n).attributes
         Address.create(:point => file.get(n).geometry, :address_id => record["ADDRESS_ID"], :geopin => record["GEOPIN"] )
      end
    end
  end
end
