require 'rails_helper'

describe RegionalHoliday do
  let(:regional_holiday) { FactoryBot.build(:regional_holiday) }

  describe 'relations' do
    it { is_expected.to have_and_belong_to_many :offices }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:day) }
    it { is_expected.to validate_presence_of(:month) }
  end

  context "with valid attributes" do
    it "is valid" do
      expect(regional_holiday).to be_valid
    end
  end

  context "with invalid day" do
    before do
      regional_holiday.day = 32
    end

    it "is not valid" do
      expect(regional_holiday).to_not be_valid
    end

    it "should include an error message" do
      regional_holiday.valid?
      expect(regional_holiday.errors[:base]).to include('date must be valid')
    end
  end

  context "with invalid month" do
    before do
      regional_holiday.month = 13
    end

    it "is not valid" do
      expect(regional_holiday).to_not be_valid
    end

    it "should include an error message" do
      regional_holiday.validate
      expect(regional_holiday.errors[:base]).to include('date must be valid')
    end
  end

  describe '.to_formatted_hash' do
    let!(:holiday_1) { create(:regional_holiday) }
    let!(:holiday_2) { create(:regional_holiday) }
    let!(:holiday_3) { create(:regional_holiday) }

    it 'returns a collection of holidays in day and month in hash format' do
      expect(described_class.to_formatted_hash).to eq([
        { month: holiday_1.month, day: holiday_1.day },
        { month: holiday_2.month, day: holiday_2.day },
        { month: holiday_3.month, day: holiday_3.day }
      ])
    end
  end
end
