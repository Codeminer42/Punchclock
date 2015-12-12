require 'spec_helper'

describe PunchesFilterForm do
  describe '#initialize' do
    context 'when pass nil params' do
      let!(:form) { PunchesFilterForm.new(nil) }

      [:since, :until, :project_id, :user_id].each do |field|
        it "assigns nil to @#{field}" do
          expect(form.send(field)).to be_nil
        end
      end
    end

    context 'when not pass nil params' do
      let!(:form) do
        PunchesFilterForm.new(
          since: 'bar',
          until: 'foo',
          project_id: 1,
          user_id: 2
        )
      end

      it 'assigns @since' do
        expect(form.since).to eq('bar')
      end

      it 'assigns @to' do
        expect(form.until).to eq('foo')
      end

      it 'assigns @project_id' do
        expect(form.project_id).to eq(1)
      end

      it 'assigns @user_id' do
        expect(form.user_id).to eq(2)
      end
    end
  end

  describe '#apply_filters' do
    let!(:relation) { double('relation') }

    context 'when @from and @to is present' do
      let!(:form) do
        PunchesFilterForm.new(since: '2013-10-01', until: '2013-10-31')
      end

      it 'apply from and to conditions' do
        expect(relation).to receive(:since).with(Date.new(2013, 10, 1))
          .and_return(relation)
        expect(relation).to receive(:until).with(Date.new(2013, 10, 31))
          .and_return(relation)
        expect(form.apply_filters(relation)).to eq(relation)
      end
    end

    context 'when only @since is present' do
      let!(:form) { PunchesFilterForm.new(since: '2013-10-01') }

      it 'apply from and to conditions' do
        expect(relation).to receive(:since).with(Date.new(2013, 10, 1))
          .and_return(relation)
        expect(form.apply_filters(relation)).to eq(relation)
      end
    end

    context 'when only @to is present' do
      let!(:form) { PunchesFilterForm.new(until: '2013-10-31') }

      it 'apply to and to conditions' do
        expect(relation).to receive(:until).with(Date.new(2013, 10, 31))
          .and_return(relation)
        expect(form.apply_filters(relation)).to eq(relation)
      end
    end

    context 'when @user_id is present' do
      let!(:form) { PunchesFilterForm.new(user_id: 1) }

      it 'apply user_id condition' do
        expect(relation).to receive(:where).with(user_id: 1).and_return(relation)
        expect(form.apply_filters(relation)).to eq(relation)
      end
    end

    context 'when @project_id is present' do
      let!(:form) { PunchesFilterForm.new(project_id: 1) }

      it 'apply project_id condition' do
        expect(relation).to receive(:where).with(project_id: 1)
          .and_return(relation)
        expect(form.apply_filters(relation)).to eq(relation)
      end
    end
  end
end
