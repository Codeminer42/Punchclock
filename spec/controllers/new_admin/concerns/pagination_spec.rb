# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::Pagination do
  describe '#paginate_record' do
    let!(:controller) { ControllerTestClassForPagination.new }
    let(:record) { Evaluation.all }

    before do
      create_list(:evaluation, 2)
    end

    context 'when decorate is false' do
      it 'does not decorate the collection' do
        result = controller.paginate_record(record, decorate: false)

        expect(result.last).to be_an_instance_of(Evaluation)
      end
    end

    context 'when decorate is true (default)' do
      it 'returns decorated record' do
        result = controller.paginate_record(record)

        expect(result.last).to be_an_instance_of(EvaluationDecorator)
      end
    end
  end
end
