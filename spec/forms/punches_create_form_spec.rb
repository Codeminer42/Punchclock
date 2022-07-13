require 'spec_helper'

describe PunchesCreateForm do
  let(:user) { create(:user) }
  let(:project) { create(:project, company: user.company) }
  let(:punches_params) do
    [
      {
        'from' => '2022-04-19T12:00:00.000Z'.to_datetime,
        'to' => '2022-04-19T15:00:00.000Z'.to_datetime,
        'project_id' => project.id
      },
      {
        'from' => '2022-04-19T16:00:00.000Z'.to_datetime,
        'to' => '2022-04-19T21:00:00.000Z'.to_datetime,
        'project_id' => project.id
      }
    ]
  end

  RSpec.shared_examples 'params are valid' do
    it 'should save' do
      expect(form.save).to be_truthy
    end

    it 'should not have errors' do
      form.save
      expect(form.errors).to be_empty
    end
  end

  RSpec.shared_examples 'params are invalid' do
    it 'should not save' do
      expect(form.save).to be_falsey
    end

    it 'should have errors' do
      form.save
      expect(form.errors).to_not be_empty
    end
  end

  describe '#initialize' do
    context 'when pass punches params' do
      let(:form) { PunchesCreateForm.new(user, punches_params) }

      it 'should all punches be instance of Punch' do
        expect(form.punches.all? { |punch| punch.is_a?(Punch) }).to be_truthy
      end
    end
  end

  describe '#save' do
    context 'when pass valid params' do
      let(:form) { PunchesCreateForm.new(user, punches_params) }

      include_examples 'params are valid'
    end

    context 'when pass invalid params' do
      let(:form) { PunchesCreateForm.new(user, []) }

      include_examples 'params are invalid'
    end

    context 'when there is already punches on same day' do
      before { create(:punch, from: '2022-04-19T10:00:00.000Z', to: '2022-04-19T11:00:00.000Z', user: user, project: project) }
      let(:form) { PunchesCreateForm.new(user, punches_params) }

      include_examples 'params are invalid'
    end
  end
end
