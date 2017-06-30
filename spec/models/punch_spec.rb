require 'spec_helper'

describe Punch do

  it { is_expected.to validate_presence_of(:from) }
  it { is_expected.to validate_presence_of(:to) }
  it { is_expected.to validate_presence_of(:project_id) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:company_id) }

  describe '#delta' do
    let(:punch) do
      build(
        :punch,
        from: Time.new(2001, 1, 5, 8),
        to: Time.new(2001, 1, 5, 12)
      )
    end

    it 'returns the time difference between from and to in hours'  do
      expect(punch.delta).to eq(4.hours)
    end
  end

  describe 'Datetime mount' do
    let(:params) do
      { from_time: '08:00', to_time: '12:00', when_day: Date.new(2001, 1, 5) }
    end
    subject(:punch) { FactoryGirl.create :punch, params }

    it 'mount datetimes correctly' do
      expect(punch.from.utc).to eq(Time.utc(2001, 1, 5, 8, 0))
      expect(punch.to.utc).to eq(Time.utc(2001, 1, 5, 12, 0))
    end
  end

  context 'times validation' do
    let(:project) { FactoryGirl.create(:project) }
    let(:user) { FactoryGirl.create(:user) }
    let(:company) { FactoryGirl.create(:company) }

    it 'does not allow retroactive end date' do

      expect(Punch.new(from: Time.new(2001, 2, 5, 8, 0, 0, 0),
                       to: Time.new(2001, 1, 5, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).not_to be_valid
    end

    it 'does not allow times from diferent days' do
      expect(Punch.new(from: Time.new(2001, 1, 4, 8, 0, 0, 0),
                       to:   Time.new(2001, 1, 5, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).not_to be_valid
    end

    it "is not valid on weekends" do
      expect(Punch.new(from: Time.new(2001, 1, 6, 8, 0, 0, 0), # Saturday
                       to:   Time.new(2001, 1, 6, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).not_to be_valid
    end

    it "is not valid on holidays" do
      expect(Punch.new(from: Time.new(2001, 12, 25, 8, 0, 0, 0), # Christimas
                       to:   Time.new(2001, 12, 25, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).not_to be_valid
    end

    it "is valid on workdays" do
      expect(Punch.new(from: Time.new(2001, 1, 4, 8, 0, 0, 0), # Thursday
                       to:   Time.new(2001, 1, 4, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).to be_valid
    end

    context "with 'allow_overtime' set to true" do
      before do
        user.allow_overtime = true
      end

      it "is valid on holidays" do
        expect(Punch.new(from: Time.new(2001, 12, 25, 8, 0, 0, 0), # Christimas
                       to:   Time.new(2001, 12, 25, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).to be_valid
      end
    end
  end
end
