# frozen_string_literal: true

require 'rails_helper'

module ActiveAdmin
  describe UsersHelper do
    describe '#skills_tags' do
      subject { helper.skills_tags(user) }

      let(:user) { create(:user) }
      let!(:expert_skill) { create(:skill, title: "Ruby") }
      let!(:capable_skill) { create(:skill, title: "Javascript") }

      let!(:user_skills) do
        [create(:user_skill, user:, experience_level: :expert, skill: expert_skill),
         create(:user_skill, user:, experience_level: :capable, skill: capable_skill)]
      end

      it "returns the tags for all user's skills" do
        expect(subject).to eq("<span class=\"status_tag yes\">#{user_skills[0].skill.title}</span> <span class=\"status_tag no\">#{user_skills[1].skill.title}</span>")
      end
    end
  end
end
