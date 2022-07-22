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
        PunchesFilterForm.new(since: '01/10/2013', until: '31/10/2013')
      end

      it 'apply from and to conditions' do
        expect(relation).to receive(:since).with(Date.new(2013, 10, 1))
          .and_return(relation)
        expect(relation).to receive(:until).with(Date.new(2013, 10, 31).end_of_day)
          .and_return(relation)
        expect(form.apply_filters(relation)).to eq(relation)
      end
    end

    context 'when only @since is present' do
      let!(:form) { PunchesFilterForm.new(since: '01/10/2013') }

      it 'apply from and to conditions' do
        expect(relation).to receive(:since).with(Date.new(2013, 10, 1))
          .and_return(relation)
        expect(form.apply_filters(relation)).to eq(relation)
      end
    end

    context 'when only @to is present' do
      let!(:form) { PunchesFilterForm.new(until: '31/10/2013') }

      it 'apply to and to conditions' do
        expect(relation).to receive(:until).with(Date.new(2013, 10, 31).end_of_day)
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

    context 'when there are punches that pass in filter criteria' do
      subject(:filtered_punches) { form.apply_filters(relation) }

      let(:relation) { Punch.where(user_id: user.id) }
      let(:user) { create(:user) }
      let(:form) do
        PunchesFilterForm.new(since: '04/11/2019', until: '04/11/2019', user_id: user.id)
      end
      let!(:valid_punch) do
        create(:punch, from: DateTime.new(2019, 11, 4, 8), to: DateTime.new(2019, 11, 4, 12), user: user  )
      end
      let!(:punches) do
        create_list(:punch, 3, from: DateTime.new(2019, 11, 1, 8), to: DateTime.new(2019, 11, 1, 12), user: user  )
      end

      it 'returns the valid punch' do
        expect(filtered_punches[0]).to eq(valid_punch)
      end
    end

    context 'when there are not punches that pass in filter criteria' do
      subject(:filtered_punches) { form.apply_filters(relation) }

      let(:relation) { Punch.where(user_id: user.id) }
      let(:user) { create(:user) }
      let(:form) do
        PunchesFilterForm.new(since: '04/11/2019', until: '04/11/2019', user_id: user.id)
      end

      let!(:punches) do
        create_list(:punch, 3, from: DateTime.new(2019, 11, 1, 9), to: DateTime.new(2019, 11, 1, 12), user: user  )
      end

      it 'returns empty' do
        expect(filtered_punches).to be_empty
      end
    end
  end
end
