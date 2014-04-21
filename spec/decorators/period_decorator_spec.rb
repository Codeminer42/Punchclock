require 'spec_helper'

describe PeriodDecorator do
  let(:period) { create :period, range: range }
  let(:decorator) { PeriodDecorator.new period }

  context 'having period range of 1/1 to 1/25 from 2014' do
    let(:range) { Date.new(2014, 1, 1)..Date.new(2014, 1, 25) }

    describe '#label' do
      it 'Janeiro de 2014' do
        expect(decorator.label).to be == 'Janeiro de 2014'
      end
    end
  end

  context 'having period range of 1/1 to 2/1 from 2014' do
    let(:range) { Date.new(2014, 1, 1)..Date.new(2014, 2, 1) }

    describe '#label' do
      it 'Janeiro/FEvereiro de 2014' do
        expect(decorator.label).to be == 'Janeiro/Fevereiro de 2014'
      end
    end
  end

 context 'having period range of 1/1 to 1/25 from 2014' do
    let(:range) { Date.new(2013, 12, 15)..Date.new(2014, 1, 15) }

    describe '#label' do
      it 'Dezembro/Janeiro de 2013/2014' do
        expect(decorator.label).to be == 'Dezembro/Janeiro de 2013/2014'
      end
    end
  end
end
