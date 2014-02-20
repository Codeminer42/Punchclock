require 'spec_helper.rb'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }

  describe "#total_hours" do
    before do
      FactoryGirl.create(:punch, {
        from: Time.new(2001, 1, 1, 8, 0, 0, 0),
        to: Time.new(2001, 1, 1, 12, 0, 0, 0),
        project_id: project.id,
        user_id: user.id
      })

      FactoryGirl.create(:punch, {
        from: Time.new(2001, 1, 1, 13, 0, 0, 0),
        to: Time.new(2001, 1, 1, 17, 0, 0, 0),
        project_id: project.id,
        user_id: user.id
      })
    end
    let(:result) { user.punches.where(from: '2001-01-01 13:00:00 UTC') }

    it "returns total of work hours" do
      expect(user.total_hours).to eq(8)
    end

    it "returns total of hours based in result" do
      expect(user.total_hours(result)).to eq(4)
    end
  end

  describe '#import_punches' do
    before { Project.stub(:find_by).and_return(project) }
    let(:file) { Rails.root.join('spec/fixtures/punches.csv').to_s }

    it 'create punches based on CSV file' do
      expect{user.import_punches(file)}
        .to change{Punch.count}.by(3)
    end
  end
end
