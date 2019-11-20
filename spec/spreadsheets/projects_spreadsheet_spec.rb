# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsSpreadsheet do
  let(:project) { create(:project) }
  let(:project_spreadsheet) { ProjectsSpreadsheet.new([project]) }
  let(:header_attributes) do
    %w[
      name
      active
      client
      created_at
      updated_at
    ].map { |attribute| Project.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      project.name,
      I18n.t(project.active.to_s),
      project.client&.name,
      I18n.l(project.created_at, format: :long),
      I18n.l(project.updated_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      project_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      expect(to_string_io).to include(project.name,
                             I18n.t(project.active.to_s),
                             I18n.l(project.created_at, format: :long),
                             I18n.l(project.updated_at, format: :long))
    end

    it 'returns spreadsheet with header' do
      expect(to_string_io).to include(*header_attributes)
    end
  end

  describe '#body' do
    subject(:body) { project_spreadsheet.body(project) }

    it 'returns body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { project_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { project_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
