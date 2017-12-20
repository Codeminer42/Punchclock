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
    context 'valid data' do
      subject(:punch) { Punch.new(from_time: '08:00', to_time: '12:00', when_day: Date.new(2001, 1, 5)) }

      it 'mount datetimes correctly' do
        expect(punch.from.utc).to eq(Time.utc(2001, 1, 5, 8, 0))
        expect(punch.to.utc).to eq(Time.utc(2001, 1, 5, 12, 0))
      end
    end

    context 'empty data' do
      subject(:punch) { Punch.new(from_time: '', to_time: '', when_day: '') }

      it 'mount datetimes correctly' do
        expect(punch.from).to eq nil
        expect(punch.to).to eq nil
      end
    end

    context 'nil data' do
      subject(:punch) { Punch.new(from_time: nil, to_time: nil, when_day: nil) }

      it 'mount datetimes correctly' do
        expect(punch.from).to eq nil
        expect(punch.to).to eq nil
      end
    end
  end

  context 'times validation' do
    let(:project) { FactoryGirl.create(:project) }
    let(:user) { FactoryGirl.create(:user) }
    let(:company) { FactoryGirl.create(:company) }
    let(:punch) { FactoryGirl.build(:punch) }

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

    context "on weekends" do
      before do
        punch.from = Time.new(2001, 1, 6, 8, 0, 0, 0) # Saturday
      end

      it "is not valid" do
        expect(punch).not_to be_valid
      end

      it "includes an error message" do
        punch.validate
        expect(punch.errors[:from]).to include('you can only select workdays')
      end
    end

    context "on holidays" do
      before do
        punch.from = Time.new(2001, 12, 25, 8, 0, 0, 0) # Christimas
      end

      it "is not valid" do
        expect(punch).not_to be_valid
      end

      it "includes an error message" do
        punch.validate
        expect(punch.errors[:from]).to include('you can only select workdays')
      end
    end

    it "is valid on workdays" do
      expect(Punch.new(from: Time.new(2001, 1, 4, 8, 0, 0, 0), # Thursday
                       to:   Time.new(2001, 1, 4, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).to be_valid
    end

    xcontext "on regional holidays" do
      before do
        RegionalHoliday.create(name: 'City Holiday',
                             day: 15,
                             month: 5,
                             offices: [user.office])
        punch.user = user
        punch.from = Time.new(2001, 5, 15, 8, 0, 0, 0) # City Holiday
        punch.to = Time.new(2001, 5, 15, 13, 0, 0, 0)
      end

      it "is not valid" do
        expect(punch).to_not be_valid
      end

      it "includes an error message" do
        punch.validate
        expect(punch.errors[:from]).to include('you can only select workdays')
      end
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

      it "is valid on regional holidays" do
        RegionalHoliday.create(name: 'City Holiday',
                               day: 15,
                               month: 5,
                               offices: [FactoryGirl.create(:office)])
        expect(Punch.new(from: Time.new(2001, 5, 15, 8, 0, 0, 0), # City Holiday
                         to:   Time.new(2001, 5, 15, 17, 0, 0, 0),
                         company: company,
                         project: project, user: user)).to be_valid
      end
    end
  end
end
