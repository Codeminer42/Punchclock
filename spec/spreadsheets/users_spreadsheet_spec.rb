# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersSpreadsheet do
  let(:user) { create(:user, :with_skills).decorate }
  let(:users_spreadsheet) { UsersSpreadsheet.new([user]) }
  let(:header_attributes) do
    %w[
      name
      email
      level
      office
      roles
      specialty
      occupation
      contract_type
      github
      skills
    ].map { |attribute| User.human_attribute_name(attribute) }
  end
  let (:enumerize_attributes) do
    [
      user.occupation
    ].map { |attr| attr.nil? ? nil : attr.text }
  end
  let (:body_attributes) do
    [
      user.name,
      user.email,
      user.level_text,
      user.office.city,
      user.roles_text,
      user.specialty_text,
      user.contract_type_text,
      user.github,
      user.skills
    ].concat(enumerize_attributes)
  end

  describe '#to_string_io' do
    subject do
      users_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      expect(users_spreadsheet).to receive(:generate_xlsx).once

      subject
    end
  end

  describe '#generate_xlsx' do
    subject(:spreadsheet) { users_spreadsheet.generate_xlsx }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.rows.first.cells.map(&:value)).to include(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.rows.last.cells.map(&:value)).to include(*body_attributes)
    end
  end

  describe '#body' do
    subject { users_spreadsheet.body(user) }

    it 'return body data' do
      is_expected.to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject { users_spreadsheet.header }

    it 'returns header data' do
      is_expected.to containing_exactly(*header_attributes)
    end
  end
end
