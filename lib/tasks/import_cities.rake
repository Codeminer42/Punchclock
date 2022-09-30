require 'net/http'
require 'json'

namespace :import do
  desc 'Import the cities from github'
  task cities: :environment do
    source = 'https://raw.githubusercontent.com/celsodantas/br_populate/master/states.json'
    response = Net::HTTP.get_response(URI.parse(source))
    cities_json = JSON.parse(response.body)

    ActiveRecord::Base.transaction do
      cities_json.each do |city_json_data|
        state = State.find_or_create_by!(
          name: city_json_data['name'],
          code: city_json_data['acronym']
        )

        city_json_data['cities'].each do |city|
          City.find_or_create_by!(name: city['name'], state: state)
        end
      end
    end
  end
end
