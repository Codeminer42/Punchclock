namespace :create do
  desc "Create an Allocation based on user first punch in the same"
  task allocations: :environment do
    Project.all.each do |project|
      project.punches.order(:from).uniq(&:user_id).each do |first_punch|
        allocation = first_punch.user.allocations.new(
          project: project,
          start_at: first_punch.from,
          company_id: project.company_id,
        )

        last_punch = first_punch.user.punches.where(project: project).order(to: :desc).first
        if last_punch.to < 1.month.ago
          allocation.end_at = last_punch.to
        end
        allocation.save
      end
    end
  end

  desc "Find or Create Questionnaire then find or create questions for these questionnaires"
  task questionnaires: :environment do
    # Configs
    CODEMINER_COMPANY_ID = 8

    ###############################################################################
    # Questionario 1
    ###############################################################################
    questionnaire_attributes = {
      title: "Avaliação Teste do MVP",
      description: "Essa é uma avaliação teste para o MVP",
      kind: "performance",
      active: false,
      company_id: CODEMINER_COMPANY_ID
    }
    questionnaire = Questionnaire.find_or_initialize_by(questionnaire_attributes)
    questionnaire.save

    # Questions
    question_attributes = {
      #questionnaire_id: 1,
      title: "Os formulários funcionam?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim;Não;Precisa de Revisão;Ta Horroroso!!!"
    question.save

    question_attributes = {
      #questionnaire_id: 1,
      title: "Ao avaliar o funcionário, o que vocês preferem?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Múltipla Escolha;Campos de Observação;Notas;Nenhuma das Anteriores;Todas as Anteriores"
    question.save

    question_attributes = {
      #questionnaire_id: 1,
      title: "Você sabia que é muito fácil cadastrar novos formulários?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim;Não"
    question.save

    ######################################################################################
    # Questionnaire 2
    ######################################################################################
    questionnaire_attributes = {
      title: "Teste de Inglês",
      description: "Este é o form de Inglês teste do MVP",
      kind: "english",
      active: false,
      company_id: CODEMINER_COMPANY_ID
    }
    questionnaire = Questionnaire.find_or_initialize_by(questionnaire_attributes)
    questionnaire.save

    # Questions
    question_attributes = {
      #questionnaire_id: 2,
      title: "How are you doing?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Great!;OK;Fine;Not OK"
    question.save

    question_attributes = {
      #questionnaire_id: 2,
      title: "What would you like to see in this MVP?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Nothing;Everything;Evaluations;It all"
    question.save

    question_attributes = {
      #questionnaire_id: 2,
      title: "Are you pleased with our job?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Not at All;Is ok; MVP;Not sure I can answer it yet"
    question.save

    question_attributes = {
      #questionnaire_id: 2,
      title: "Did you Know that you can see the evaluation at the Miner's Admin Page?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Yes!;No!"
    question.save

    ######################################################################################
    # Questionnaire 3
    ######################################################################################
    questionnaire_attributes = {
      title: "Avaliação Trimestral do Miner",
      description: "Mais um teste para o MVP",
      kind: "performance",
      active: false,
      company_id: CODEMINER_COMPANY_ID
    }
    questionnaire = Questionnaire.find_or_initialize_by(questionnaire_attributes)
    questionnaire.save


    # Questions
    question_attributes = {
      #questionnaire_id: 3,
      title: "Como o Miner está com os clientes?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Eles o adoram;Bem;Não sei responder;Ruim;Péssimo"
    question.save

    question_attributes = {
      #questionnaire_id: 3,
      title: "O Miner apresentou evolução técnica desde sua última avaliação?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim; evolução significativa;Sim; pouca evolução;Está no mesmo nível técnico"
    question.save

    question_attributes = {
      #questionnaire_id: 3,
      title: "O Miner apresentou evolução em liderança e resolução de problemas?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim; bastante;Não; nem um pouco"
    question.save

    question_attributes = {
      #questionnaire_id: 3,
      title: "Você recomenda a evolução técnica deste Miner?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim; com certeza;Indiferente;Não; de jeito nenhum;Demita!!!"
    question.save


    ######################################################################################
    # Questionnaire 4
    ######################################################################################
    questionnaire_attributes = {
      title: "Análise de Evolução do Miner",
      description: "Formulário com base na https://pt.surveymonkey.com/r/DJLX76H? analise de evução fornecida pelo Alessandro Dias em 08/05/19.",
      kind: "performance",
      active: true,
      company_id: CODEMINER_COMPANY_ID
    }
    questionnaire = Questionnaire.find_or_initialize_by(questionnaire_attributes)
    questionnaire.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "Análise Técnica",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Estagiário;Júnior;Júnior Plus;Pleno;Pleno Plus;Sênior;Sênior Plus"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "Evolução Técnica",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Acomodado;Dentro da Expectativa;Superou as Expectativas"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "Nível de Inglês",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Insuficiente;Suficiente;Superou as Expectativas"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "Evolução do nível de Inglês",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Acomodado;Dentro da Expectativa;Superou as Expectativas"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "O Miner é comprometido com Horário?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim;Não"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "Como ele(a) se comporta na evolução do escritório?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Aprendiz;Neutro;Mentor"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "O Miner contribuiu para projetos Open Source?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim;Não"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "O Miner contribuiu em projetos internos? (Central, Marvin, Punch, Miner Camp, etc)",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim;Não"
    question.save

    question_attributes = {
      #questionnaire_id: 4,
      title: "O Miner palestrou ou organizou eventos para a Comunidade Técnica?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Sim;Não"
    question.save



    ######################################################################################
    # Questionnaire 5
    ######################################################################################
    questionnaire_attributes = {
      title: "English Level",
      description: "Questionário baseado no documento criado pelo Tiarly sobre os pontos que devem ser avaliados durante a entrevista do Miner.",
      kind: "english",
      active: true,
      company_id: CODEMINER_COMPANY_ID
    }
    questionnaire = Questionnaire.find_or_initialize_by(questionnaire_attributes)
    questionnaire.save

    question_attributes = {
      #questionnaire_id: 5,
      title: "Listening: The ability to understand someone in english (how good their ears are)",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Meets expectations high ( 3 points );Meets expectations ( 2 points );Slightly underperforms ( 1 points );Does not meet expectations ( 0 points )"
    question.save

    question_attributes = {
      #questionnaire_id: 5,
      title: "Communication: The ability to be able to maintain conversation to someone (can communicate or not?)",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Meets expectations high ( 3 points );Meets expectations ( 2 points );Slightly underperforms ( 1 points );Does not meet expectations ( 0 points )"
    question.save

    question_attributes = {
      #questionnaire_id: 5,
      title: "Vocabulary: After communication is established, how well or how good are the sentences? Does the person repeats the same expressions, over and over? Can he adapt depending on the question and use different words/expressions ?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Meets expectations high ( 3 points );Meets expectations ( 2 points );Slightly underperforms ( 1 points );Does not meet expectations ( 0 points )"
    question.save

    question_attributes = {
      #questionnaire_id: 5,
      title: "Accuracy: After communication is established, how well or how good are the sentences grammar wise? Can the person use the  three main verb tenses: simple present, simple past and future correctly? Or Is it using present when he should be using past instead or vice versa? For more advanced users, can they use present perfect correctly? Is he making use of modals (Should, Must, Might, Could) properly?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Meets expectations high ( 3 points );Meets expectations ( 2 points );Slightly underperforms ( 1 points );Does not meet expectations ( 0 points )"
    question.save

    question_attributes = {
      #questionnaire_id: 5,
      title: "Pronunciation: After communication is established, and the person is able to say sentences, regardless if is correctly or not, is he making good use of pronunciation?",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Meets expectations high ( 3 points );Meets expectations ( 2 points );Slightly underperforms ( 1 points );Does not meet expectations ( 0 points )"
    question.save

    question_attributes = {
      #questionnaire_id: 5,
      title: "Fluency: After communication is established, this is usually the easiest or hardest depending on the person to give a rubric, since it's regarding how good the conversation has been, sounding almost like a natural conversation on your mother language. You should evaluate this comparing every single one of the past criterias combined.",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Meets expectations high ( 3 points );Meets expectations ( 2 points );Slightly underperforms ( 1 points );Does not meet expectations ( 0 points )"
    question.save

    question_attributes = {
      #questionnaire_id: 5,
      title: "English levels we can have ( From lowest to highest)",
      kind: "multiple_choice",
    }
    question = questionnaire.questions.find_or_initialize_by(question_attributes)
    question.raw_answer_options = "Basic ( 0 ~ 5 points );Elementary ( 6 ~ 7 points );Pre-Intermediate (  8 ~ 10 points );Intermediate ( 10 ~ 12 points );Upper-Intermediate ( 13 ~ 14 points );Advanced ( 15 ~ 17 points );Fluent ( 18 points )"
    question.save
  end
end
