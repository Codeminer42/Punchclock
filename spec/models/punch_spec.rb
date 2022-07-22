require 'spec_helper'

describe Punch do
  include ActiveSupport::Testing::TimeHelpers

  describe 'relations' do
    it { is_expected.to belong_to :project }
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :company }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:from) }
    it { is_expected.to validate_presence_of(:to) }
  end

  describe '.from_last_month' do
    let(:last_month_punches) do
      punches = []

      # Create AM and PM punches on valid days from 2018-06-01 to 2018-07-31.
      ("2018-06-01".to_date.."2018-07-31".to_date).each do |day|
        punch_am = build :punch, from: day +  9.hours, to: day + 12.hours
        punch_pm = build :punch, from: day + 13.hours, to: day + 18.hours

        [punch_am, punch_pm].each do |punch|
          punch.save and punches << punch if punch.valid?
        end
      end

      punches.select do |punch|
        punch.from.between? "2018-06-16".to_date, "2018-07-15".to_date
      end
    end

    before do
      travel_to "2018-07-28".to_date
    end

    after do
      travel_back
    end

    it 'returns only punches from last month' do
      expect(Punch.from_last_month).to match_array last_month_punches
    end
  end

  describe '#delta' do
    let(:punch) do
      day = "2001-01-05".to_date
      build :punch, from: day + 9.hours, to: day + 13.hours
    end

    it 'returns the time difference between from and to in hours'  do
      expect(punch.delta).to eq(4.hours)
    end
  end

  describe '#delta_as_hour' do
    let(:punch) do
      from = "2018-07-03 13:29".to_time
      to = from + 4.hours + 2.minutes

      build :punch, from: from, to: to
    end

    it 'returns delta as a string %H:%M' do
      expect(punch.delta_as_hour).to eq '04:02'
    end
  end

  describe '#date' do
    let(:punch) { build :punch }

    it { expect(punch.date).to eq punch.from.to_date }
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
    let(:project) { FactoryBot.create(:project) }
    let(:user) { FactoryBot.create(:user) }
    let(:company) { FactoryBot.create(:company) }
    let(:punch) { FactoryBot.build(:punch) }
    let(:error_message) { I18n.t(:must_be_workday, scope: "activerecord.errors.models.punch.attributes.when_day") }

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

    context 'delta validation' do
      context 'when times are equal' do
        let(:error_message) { I18n.t(:cant_be_equal, scope: "activerecord.errors.models.punch.attributes.from_time") }
        let(:punch) {
          Punch.new(from: Time.new(2022, 1, 5, 8, 0, 0, 0),
                    to:   Time.new(2022, 1, 5, 8, 0, 0, 0),
                    company: company,
                    project: project, user: user)
        }

        it 'is not valid' do
          expect(punch).not_to be_valid
        end
  
        it "includes an error message" do
          punch.validate
          expect(punch.errors[:from_time]).to include(error_message)
        end
      end

      context 'when from time is greater than to time' do
        let(:error_message) { I18n.t(:cant_be_greater, scope: "activerecord.errors.models.punch.attributes.from_time") }
        let(:punch) {
          Punch.new(from: Time.new(2022, 1, 5, 9, 0, 0, 0),
                    to:   Time.new(2022, 1, 5, 8, 0, 0, 0),
                    company: company,
                    project: project, user: user)
        }

        it 'is not valid' do
          expect(punch).not_to be_valid
        end
  
        it "includes an error message" do
          punch.validate
          expect(punch.errors[:from_time]).to include(error_message)
        end
      end
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
        expect(punch.errors[:when_day]).to include(error_message)
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
        expect(punch.errors[:when_day]).to include(error_message)
      end
    end

    it "is valid on workdays" do
      expect(Punch.new(from: Time.new(2001, 1, 4, 8, 0, 0, 0), # Thursday
                       to:   Time.new(2001, 1, 4, 17, 0, 0, 0),
                       company: company,
                       project: project, user: user)).to be_valid
    end

    context "on regional holidays" do
      let(:user) { FactoryBot.create(:user) }

      before do
        RegionalHoliday.create(name: 'City Holiday',
                             day: 15,
                             month: 5,
                             company: user.office.company,
                             offices: [user.office])
        punch.user = user
        punch.from = Time.new(2001, 5, 15, 8, 0, 0, 0)
        punch.to = Time.new(2001, 5, 15, 13, 0, 0, 0)
      end

      it "is not valid" do
        expect(punch).to_not be_valid
      end

      it "includes an error message" do
        punch.validate
        expect(punch.errors[:when_day]).to include(error_message)
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
                               offices: [FactoryBot.create(:office)])
        expect(Punch.new(from: Time.new(2001, 5, 15, 8, 0, 0, 0), # City Holiday
                         to:   Time.new(2001, 5, 15, 17, 0, 0, 0),
                         company: company,
                         project: project, user: user)).to be_valid
      end
    end
  end
end
