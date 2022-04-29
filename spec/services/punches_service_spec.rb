require 'rails_helper'

RSpec.describe PunchesService do
  let(:company) { create(:company) }
  let(:user) { create(:user, :with_token, company: company) }
  let(:project) { create(:project, company: user.company) }

  describe "#create" do
    context "with right arguments" do
      let(:punches) {
        [
          {
            "from" => "2022-04-19T12:00:00",
            "to" => "2022-04-19T15:00:00",
            "project_id" => "#{project.id}"
          },
          {
            "from" => "2022-04-19T16:00:00",
            "to" => "2022-04-19T21:00:00",
            "project_id" => "#{project.id}"
          }
        ]
      }

      let(:office) { create(:office, :with_holiday) }

      it "returns the created punches" do
        created_punches = described_class.create(punches, user).map { |punch| {from: punch['from'].strftime("%FT%T"), to: punch['to'].strftime("%FT%T"), project_id: punch['project_id'].to_s } }
        expected_punches = punches.map { |punch| {from: punch["from"], to: punch["to"], project_id: punch["project_id"].to_s } }
        expect(created_punches).to match_array(expected_punches)
      end
    end

    context 'when does have another punch on same date' do
      let(:first_punches) {
        [
          {
            "from" => "2022-04-19T12:00:00",
            "to" => "2022-04-19T15:00:00",
            "project_id" => "#{project.id}"
          },
          {
            "from" => "2022-04-19T16:00:00",
            "to" => "2022-04-19T21:00:00",
            "project_id" => "#{project.id}"
          }
        ]
      }

      let(:second_punches) {
        [
          {
            "from" => "2022-04-19T10:00:00",
            "to" => "2022-04-19T12:00:00",
            "project_id" => "#{project.id}"
          },
          {
            "from" => "2022-04-19T15:00:00",
            "to" => "2022-04-19T20:00:00",
            "project_id" => "#{project.id}"
          }
        ]
      }

      it 'returns created punches and deletes the last punches' do
        first_created_punches_db = described_class.create(first_punches, user)
        first_created_punches = first_created_punches_db.map { |punch| {from: punch['from'].strftime("%FT%T"), to: punch['to'].strftime("%FT%T"), project_id: punch['project_id'].to_s } }
        first_expected_punches = first_punches.map { |punch| {from: punch['from'], to: punch['to'], project_id: punch['project_id'].to_s } }
        expect(first_created_punches).to match_array(first_expected_punches)

        second_created_punches_db = described_class.create(second_punches, user)
        second_created_punches = second_created_punches_db.map { |punch| {from: punch['from'].strftime("%FT%T"), to: punch['to'].strftime("%FT%T"), project_id: punch['project_id'].to_s } }
        second_expected_punches = second_punches.map { |punch| {from: punch['from'], to: punch['to'], project_id: punch['project_id'].to_s } }
        expect(second_created_punches).to match_array(second_expected_punches)

        first_created_punches_db.each do |punch|
          expect { punch.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
