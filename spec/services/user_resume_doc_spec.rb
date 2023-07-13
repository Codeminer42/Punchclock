require 'rails_helper'

describe UserResumeDoc do

  let(:doc) { UserResumeDoc.new }
  let(:skill) { build(:user_skill) }
  let(:skills) { build_list(:user_skill, 8) << skill }
  let(:professional_xp) { build(:professional_experience) }
  let(:all_professional_xp) { build_list(:professional_experience, 5) << professional_xp }
  let(:education_xp) { build(:education_experience) }
  let(:all_educational_xp) { build_list(:education_experience, 5) << education_xp }
  let(:contribution) { build(:contribution, :approved, :with_description) }
  let(:contributions) { build_list(:contribution, 5, :approved, :with_description) << contribution }
  let(:talk) { build(:talk) }
  let(:talks) { build_list(:talk, 5) << talk }
  let!(:user) { 
    create(:user,
           user_skills: skills,
           professional_experiences: all_professional_xp,
           education_experiences: all_educational_xp,
           contributions: contributions,
           talks: talks
          ) 
  }

  describe '.doc_template' do
    it 'should have all the required bookmarks' do
      expect(doc.doc_template.bookmarks.keys)
        .to include('skills', 'companies', 'education', 'contribution', 'talks')
    end
  end

  describe '.doc_element' do
    it 'should have all the required placeholders' do
      expect(doc.doc_element.paragraphs.map(&:text).join(' '))
        .to include('_item_', '_job_description_', 'job_date', 'course_name', 'project_name', 'pr_description', 'event_name')
    end
  end

  describe '#call' do
    let(:doc_final_text) { doc.doc_template.paragraphs.map(&:text).join(' ') }

    before { doc.call(user) }

    it 'should call the mounting methods with the correct arguments' do
      allow(doc).to receive(:add_user_info)
      allow(doc).to receive(:mount_skill_section)
      allow(doc).to receive(:mount_professional_section)
      allow(doc).to receive(:mount_education_section)
      allow(doc).to receive(:mount_contribution_section)
      allow(doc).to receive(:mount_talk_section)

      job_experiences = double('JobExperiences')
      education_experiences = double('EducationExperiences')
      contribution_experiences = double('ContributionExperiences')
      talk_experiences = double('TalkExperiences')

      allow(user).to receive_message_chain(:skills, :pluck).and_return(['Ruby', 'JavaScript'])
      allow(user).to receive_message_chain(:professional_experiences, :order, :decorate).and_return(job_experiences)
      allow(user).to receive_message_chain(:education_experiences, :decorate).and_return(education_experiences)
      allow(user).to receive_message_chain(:contributions, :approved, :order, :decorate, :group_by).and_return(contribution_experiences)
      allow(user).to receive_message_chain(:talks, :decorate).and_return(talk_experiences)

      expect(doc).to receive(:mount_skill_section).with(['Ruby', 'JavaScript'])
      expect(doc).to receive(:mount_professional_section).with(job_experiences)
      expect(doc).to receive(:mount_education_section).with(education_experiences)
      expect(doc).to receive(:mount_contribution_section).with(contribution_experiences)
      expect(doc).to receive(:mount_talk_section).with(talk_experiences)

      doc.call(user)
    end


    it 'should not add any placeholder to the final document' do
      expect(doc_final_text)
        .to_not include('_item_', '_job_description_', '_date_', 'course_name', 'project_name', 'pr_description', 'event_name')
    end

    it 'should add user info to the document' do
      expect(doc_final_text).to include(user.name)
    end

    it 'should add user skills to the document' do
      expect(doc_final_text).to include(skill.skill.title)
    end

    it 'should add user professional experiences to the document' do
      expect(doc_final_text).to include(professional_xp.company)
      expect(doc_final_text).to include(professional_xp.position)
    end

    it 'should add user education experiences to the document' do
      expect(doc_final_text).to include(education_xp.institution)
      expect(doc_final_text).to include(education_xp.course)
    end

    it 'should add user contributions to the document' do
      expect(doc_final_text).to include(contribution.decorate.repository_name)
      expect(doc_final_text).to include(contribution.decorate.description)
    end

    it 'should add user talks to the document' do
      expect(doc_final_text).to include(talk.event_name)
      expect(doc_final_text).to include(talk.talk_title)
    end
  end

  describe '#save' do
    it 'should save the document with the correct filename' do
      doc.instance_variable_set(:@filename, 'John_Doe_RESUME.docx')

      expect(doc.instance_variable_get(:@doc_template)).to receive(:save).with('John_Doe_RESUME.docx')

      doc.save
    end
  end

  describe '#to_string_io' do
    it 'should return the content of the document as a string' do
      expect(doc.instance_variable_get(:@doc_template)).to receive(:stream).and_return(double(read: 'Document content'))

      result = doc.to_string_io

      expect(result).to eq('Document content')
    end
  end
end
