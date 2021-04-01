# frozen_string_literal: true

RSpec.describe PunchesPaginationDecorator do
  describe '#total_hours' do
    let(:params) { { page: 2, per: 25 } }
    let(:punches_pagination_decorator) { PunchesPaginationDecorator.new(params, punches) }

    context 'when not have punches' do
      let(:punches) { Punch.none }

      it 'returns total_hours' do
        expect(punches_pagination_decorator.total_hours).to eql('00:00')
      end
    end

    context 'when have punches' do
      let(:punch) do
        create(:punch, from: DateTime.new(2021, 3, 3, 1, 0, 0),
                       to: DateTime.new(2021, 3, 3, 2, 0, 0))
      end
      let(:punches) { Punch.where(id: punch.id) }

      it 'returns total_hours' do
        expect(punches_pagination_decorator.total_hours).to eql('01:00')
      end
    end
  end
end
