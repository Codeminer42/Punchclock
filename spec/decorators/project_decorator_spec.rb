# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectDecorator do
  describe '#market' do
    subject(:project) { build_stubbed(:project, market: market).decorate }

    context 'when is from internal market' do
      let(:market) { :internal }

      it 'returns "Interno"' do
        expect(subject.market).to eq('Interno')
      end
    end

    context 'when is from external market' do
      let(:market) { :international }

      it 'returns "Externo"' do
        expect(subject.market).to eq('Externo')
      end
    end

    context "when market wasn't informed" do
      let(:market) { nil }

      it 'returns "N/A"' do
        expect(subject.market).to eq('N/A')
      end
    end
  end

  describe '#active_class' do
    context 'when project is active' do
      subject(:project) { build_stubbed(:project, :active).decorate }

      it 'returns css class that fills svg with green color' do
        expect(subject.active_class).to eq('fill-green-500')
      end
    end

    context 'when project is inactive' do
      subject(:project) { build_stubbed(:project, :inactive).decorate }

      it 'returns css class with no fill' do
        expect(subject.active_class).to eq('fill-none')
      end
    end
  end
end
