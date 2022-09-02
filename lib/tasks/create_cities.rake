namespace :cities do
  desc "Create cities"
  task create_cities: :environment do
    cities = [
      {name: 'Natal', state_code: 'RN'},
      {name: 'Teresina', state_code: 'PI'},
      {name: 'Anápolis', state_code: 'GO'},
      {name: 'Goiania', state_code: 'GO'},
      {name: 'Brasilia', state_code: 'DF'},
      {name: 'Campinas', state_code: 'SP'},
      {name: 'Novo Hamburgo', state_code: 'RS'},
      {name: 'São Paulo', state_code: 'SP'},
      {name: 'Guarapuava', state_code: 'PR'},
      {name: 'Santa Maria', state_code: 'RS'},
      {name: 'Vitória', state_code: 'ES'},
      {name: 'Poços de Caldas', state_code: 'MG'},
      {name: 'Ribeirão Preto', state_code: 'SP'},
      {name: 'Florianópolis', state_code: 'SC'},
      {name: 'Torres', state_code: 'RS'},
      {name: 'Morrinhos', state_code: 'GO'},
    ]

    ActiveRecord::Base.transaction do
      states = State.all.pluck(:code, :id).to_h

      cities.each do |ct|
        City.find_or_create_by!(name: ct[:name]) do |city|
          city.state_id = states[ct[:state_code]]
        end
      end
    end
  end
end