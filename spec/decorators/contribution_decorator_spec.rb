require 'rails_helper'

RSpec.describe ContributionDecorator do

  describe '#user_short_name' do
    subject {described_class.new(contribution).user_short_name}

    let(:contribution) {build_stubbed(:contribution, user: user)}

    context 'when user name has 3 names' do
      let(:user) {build_stubbed(:user, name: 'Name1 Name2 Name3')}

      it {is_expected.to eq 'Name1 Name3'}
    end

    context 'when user name has 2 names' do
      let(:user) {build_stubbed(:user, name: 'Name1 Name2')}

      it {is_expected.to eq 'Name1 Name2'}
    end

    context 'when user name has 1 name' do
      let(:user) {build_stubbed(:user, name: 'Name1')}

      it {is_expected.to eq 'Name1'}
    end

    context 'when user name is empty' do
      let(:user) {build_stubbed(:user, name: '')}

      it {is_expected.to eq ''}
    end

  end

  describe '#reviewed_by_name' do
    subject {described_class.new(contribution).reviewed_by_short_name}

    let(:contribution) {build_stubbed(:contribution, reviewed_by: reviewed_by)}

    context 'when reviewed name has 3 names' do
      let(:reviewed_by) {build_stubbed(:user, name: 'A_Name1 B_Name2 C_Name3')}

      it {is_expected.to eq 'AC'}
    end

    context 'when reviewed name has names in downcase and upcase' do
      let(:reviewed_by) {build_stubbed(:user, name: 'A_Name1 b_Name2 c_Name3')}

      it {is_expected.to eq 'AC'}
    end

    context 'when reviewed name has 2 names' do
      let(:reviewed_by) {build_stubbed(:user, name: 'A_Name1 b_Name2')}

      it {is_expected.to eq 'AB'}
    end

    context 'when reviewed name has 1 name' do
      let(:reviewed_by) {build_stubbed(:user, name: 'A_Name1')}

      it {is_expected.to eq 'A'}
    end

    context 'when reviewed name is empty' do
      let(:reviewed_by) {build_stubbed(:user, name: '')}

      it {is_expected.to eq ''}
    end

  end

  describe '#created_at' do
    subject {described_class.new(contribution).created_at}

    let(:contribution) {build_stubbed(:contribution, created_at: DateTime.parse('2022-08-26T16:50'))}

    it {is_expected.to eq '26/08/2022'}
  end

  describe '#reviewed_at' do
    subject {described_class.new(contribution).reviewed_at}

    let(:contribution) {build_stubbed(:contribution, reviewed_at: DateTime.parse('2022-08-26T16:50'))}

    it {is_expected.to eq '26/08/2022'}
  end

end
