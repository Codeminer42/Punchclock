namespace :fill do
  desc "TODO"
  task miners: :environment do

    CODEMINER_COMPANY_ID = 8

    # Office Names
    OFFICE_ANAPOLIS        = 'Anapolis'
    OFFICE_BELO_HORIZONTE  = 'Belo Horizonte'
    OFFICE_BATATAIS        = 'Batatais'
    OFFICE_CAMPINAS        = 'Campinas'
    OFFICE_GOIANIA         = 'Goiania'
    OFFICE_GUARAPUAVA      = 'Guarapuava'
    OFFICE_NATAL           = 'Natal'
    OFFICE_NOVO_HAMBURGO   = 'Novo Hamburgo'
    OFFICE_POCOS_DE_CALDAS = 'Poços de Caldas'
    OFFICE_SANTA_MARIA     = 'Santa Maria'
    OFFICE_SOROCABA        = 'Sorocaba'
    OFFICE_SAO_PAULO       = 'São Paulo'
    OFFICE_TERESINA        = 'Teresina'
    OFFICE_SANTA_CATARINA  = 'Santa Catarina'


    ###############################################################################
    # Anápolis
    ###############################################################################
    office = Office.find_by(city: OFFICE_ANAPOLIS)
    user = User.find_or_initialize_by(email: 'dieggo.faustino@codeminer42.com') do |user|
      user.name = 'Diêggo Lucas Machado Faustino'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'helio.junior@codeminer42.com') do |user|
      user.name = 'Helio Vitorino Soares Junior'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'jonatas.rancan@codeminer42.com') do |user|
      user.name = 'Jônatas Rancan de Souza'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'jonathan.bruno@codeminer42.com') do |user|
      user.name = 'Jonathan Bruno Silva Santos'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'tauan.tathiell@codeminer42.com') do |user|
      user.name = 'Tauan Tathiell de Aleluia Camargo'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Belo Horizonte
    ###############################################################################
    office = Office.find_by(city: OFFICE_BELO_HORIZONTE)
    user = User.find_or_initialize_by(email: 'gabriel.sobrinho@codeminer42.com') do |user|
      user.name = 'Gabriel Sobrinho'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'juarez.lustosa@codeminer42.com') do |user|
      user.name = 'Juarez Lustosa'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Batatais
    ###############################################################################
    office = Office.find_by(city: OFFICE_BATATAIS)
    user = User.find_or_initialize_by(email: 'andre.pereira@codeminer42.com') do |user|
      user.name = 'André Rodrigues Pereira'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'bruno.castro@codeminer42.com') do |user|
      user.name = 'Bruno Castro Fernandes'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'rodrigo.virgilio@codeminer42.com') do |user|
      user.name = 'Rodrigo Virgilio'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'ronaldo.araujo@codeminer42.com') do |user|
      user.name = 'Ronaldo de Souza Araújo'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Campinas
    ###############################################################################
    office = Office.find_by(city: OFFICE_CAMPINAS)
    user = User.find_or_initialize_by(email: 'julia.furlani@codeminer42.com') do |user|
      user.name = 'Julia Furlani'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'patricia.bastos@codeminer42.com') do |user|
      user.name = 'Patricia Luz Bastos'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'rauan.assis@codeminer42.com') do |user|
      user.name = 'Rauan Assis'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'talysson.oliveira@codeminer42.com') do |user|
      user.name = 'Talysson de Oliveira Cassiano'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD

    ###############################################################################
    # Goiânia
    ###############################################################################
    office = Office.find_by(city: OFFICE_GOIANIA)
    user = User.find_or_initialize_by(email: 'wender.jean@codeminer42.com') do |user|
      user.name = 'Wender Jean de Sousa Freese'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'lairton.lelis@codeminer42.com') do |user|
      user.name = 'Lairton Lelis da Fonseca Junior'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'moises.rodrigues@codeminer42.com') do |user|
      user.name = 'Moisés Hilario Rodrigues'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Guarapuava
    ###############################################################################
    office = Office.find_by(city: OFFICE_GUARAPUAVA)
    alessandro = User.find_or_initialize_by(email: 'alessandro.dias@codeminer42.com') do |user|
      user.name = 'Alessandro Dias'
    end
      alessandro.occupation = 'engineer'
      alessandro.role ='senior_plus'
      alessandro.office = office
      alessandro.company_id = CODEMINER_COMPANY_ID
      office.update(head: alessandro) # HEAD Guarapuava

    user = User.find_or_initialize_by(email: 'adriano.kosta@codeminer42.com') do |user|
      user.name = 'Adriano Costa'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'alexandre.karpinski@codeminer42.com') do |user|
      user.name = 'Alexandre Karpinski'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'gabriel.muller@codeminer42.com') do |user|
      user.name = 'Gabriel Muller'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'lucas.gois@codeminer42.com') do |user|
      user.name = 'Lucas Gois'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'cassiano.sampaio@codeminer42.com') do |user|
      user.name = 'Cassiano Blonski Sampaio'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'stheffany@codeminer42.com') do |user|
      user.name = 'Stheffany Hadlich'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Natal
    ###############################################################################
    office = Office.find_by(city: OFFICE_NATAL)
    user = User.find_or_initialize_by(email: 'halan.pinheiro@codeminer42.com') do |user|
      user.name = 'Halan Pinheiro'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'elma.santos@codeminer42.com') do |user|
      user.name = 'Elma Santos'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'fladson.thiago@codeminer42.com') do |user|
      user.name = 'Fladson Thiago'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'leonardo.negreiros@codeminer42.com') do |user|
      user.name = 'Leonardo Negreiros de Oliveira'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'luan.goncalves@codeminer42.com') do |user|
      user.name = 'Luan Gonçalves'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'luciano.dantas@codeminer42.com') do |user|
      user.name = 'Luciano Dantas'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'sergio.varela@codeminer42.com') do |user|
      user.name = 'Sergio Varela'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'thiago@codeminer42.com') do |user|
      user.name = 'Thiago da Cruz'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'maychell.oliveira@codeminer42.com') do |user|
      user.name = 'Maychell Oliveira'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'willane.paiva@codeminer42.com') do |user|
      user.name = 'Willane Paiva'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Novo Hamburgo
    ###############################################################################
    office = Office.find_by(city: OFFICE_NOVO_HAMBURGO)
    user = User.find_or_initialize_by(email: 'abner.alves@codeminer42.com') do |user|
      user.name = 'Abner Alves'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'rodrigo.boniatti@codeminer42.com') do |user|
      user.name = 'Rodrigo Boniatti'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'ivan.stumpf@codeminer42.com') do |user|
      user.name = 'Ivan Stumpf'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'tiarli.oliveira@codeminer42.com') do |user|
      user.name = 'Tiarli Oliveira'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'matheus.azzi@codeminer42.com') do |user|
      user.name = 'Matheus Azzi'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'felipe.nolleto@codeminer42.com') do |user|
      user.name = 'Felipe Nolleto'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'victor.kunzler@codeminer42.com') do |user|
      user.name = 'Victor Kunzler'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'paulo.diovani@codeminer42.com') do |user|
      user.name = 'Paulo Diovani'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'iago.dahlem@codeminer42.com') do |user|
      user.name = 'Iago Dahlem'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Poços de Caldas
    ###############################################################################
    office = Office.find_by(city: OFFICE_POCOS_DE_CALDAS)
    user = User.find_or_initialize_by(email: 'diego.thomaz@codeminer42.com') do |user|
      user.name = 'Diego Thomaz'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'kim.freitas@codeminer42.com') do |user|
      user.name = 'Kim Emmanuel'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'rafael.martins@codeminer42.com') do |user|
      user.name = 'Rafael Martins'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Santa Maria
    ###############################################################################
    office = Office.find_by(city: OFFICE_SANTA_MARIA)
    user = User.find_or_initialize_by(email: 'thiago.alves@codeminer42.com') do |user|
      user.name = 'Thiago Alves Luiz'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'fabricio.albarnaz@codeminer42.com') do |user|
      user.name = 'Fabrício Lopes Albarnaz'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'felipe.flores@codeminer42.com') do |user|
      user.name = 'Felipe Lovato Flores'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'augusto.foletto@codeminer42.com') do |user|
      user.name = 'Antônio Augusto Foletto'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'gustavo.valvassori@codeminer42.com') do |user|
      user.name = 'Gustavo Fão Valvassori'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'joao.saldanha@codeminer42.com') do |user|
      user.name = 'João Pedro Raskopf Denardin Saldanha'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'victor.vicari@codeminer42.com') do |user|
      user.name = 'Victor Vicari'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # Sorocaba
    ###############################################################################
    office = Office.find_by(city: OFFICE_SOROCABA)
    user = User.find_or_initialize_by(email: 'guilherme.moreira@codeminer42.com') do |user|
      user.name = 'Guilherme Vinicius'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD
    user = User.find_or_initialize_by(email: 'julio.cesar@codeminer42.com') do |user|
      user.name = 'Julio César Fortunato'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save

    ###############################################################################
    # São Paulo
    ###############################################################################
    office = Office.find_by(city: OFFICE_SAO_PAULO)
    user = User.find_or_initialize_by(email: 'elias.rodrigues@codeminer42.com') do |user|
      user.name = 'Elias Rodrigues'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: alessandro) # HEAD de SP é o Alessandro

    ###############################################################################
    # Teresina
    ###############################################################################
    office = Office.find_by(city: OFFICE_TERESINA)
    user = User.find_or_initialize_by(email: 'alceu.medeiros@codeminer42.com') do |user|
      user.name = 'Alceu Robson'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'jose.eduardo@codeminer42.com') do |user|
      user.name = 'Eduardo Alencar'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'willame.soares@codeminer42.com') do |user|
      user.name = 'Willame Soares'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'samuel.flores@codeminer42.com') do |user|
      user.name = 'Samuel Flores'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'yuri.araujo@codeminer42.com') do |user|
      user.name = 'Yuri Delfino'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'cyrus@codeminer42.com') do |user|
      user.name = 'Cyrus Brito'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'marcle.rodrigues@codeminer42.com') do |user|
      user.name = 'Marcle Rodrigues'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'renan.bona@codeminer42.com') do |user|
      user.name = 'Renan Bona'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'romulo.storel@codeminer42.com') do |user|
      user.name = 'Romulo Storel'
    end
      user.occupation = 'engineer'
      user.role ='senior_plus'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
      office.update(head: user) # HEAD

    ###############################################################################
    # Santa Catarina
    ###############################################################################
    office = Office.find_by(city: OFFICE_SANTA_CATARINA)
    user = User.find_or_initialize_by(email: 'marcelo.alexandre@codeminer42.com') do |user|
      user.name = 'Marcelo Alexandre'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
    user = User.find_or_initialize_by(email: 'joao.mangilli@codeminer42.com') do |user|
      user.name = 'João Mangilli'
    end
      user.occupation = 'engineer'
      user.role ='junior'
      user.office = office
      user.company_id = CODEMINER_COMPANY_ID
      user.save
  end
end
