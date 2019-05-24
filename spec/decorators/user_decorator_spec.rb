# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDecorator do
  describe '#current_allocation' do
    let(:user) { create(:user).decorate }

    context 'when user is allocated' do
      let!(:allocation) { create(:allocation, user: user) }

      it 'returns project link' do
        link = "<a href=\"http://localhost:3000/admin/projects/#{allocation.project_id}\">#{CGI.escape_html(allocation.project.name)}</a>"

        expect(user.current_allocation).to eq(link)
      end
    end

    context 'when no allocation is set' do
      it 'returns not allocated' do
        expect(user.current_allocation).to eq('Não Alocado')
      end
    end
  end

  describe '#role' do
    context 'when role is set' do
      subject(:user) { build_stubbed(:user, role: 'trainee').decorate }

      it 'returns user role' do
        expect(subject.role).to eq('Trainee')
      end
    end

    context 'when role is nil' do
      subject(:user) { build_stubbed(:user, role: nil).decorate }

      it 'returns N/A' do
        expect(subject.role).to eq('N/A')
      end
    end
  end

  describe '#english_level' do
    subject(:user) { build_stubbed(:user).decorate }

    context 'when english_level is set' do
      before { allow_any_instance_of(User).to receive(:english_level).and_return('fluent') }

      it 'returns user english_level' do
        expect(subject.english_level).to eq('Fluent')
      end
    end

    context 'when english_level is nil' do
      before { allow_any_instance_of(User).to receive(:english_level).and_return(nil) }

      it 'returns not evaluated' do
        expect(subject.english_level).to eq('Não avaliado')
      end
    end
  end

  describe '#english_score' do
    subject(:user) { build_stubbed(:user).decorate }

    context 'when english_score is set' do
      before { allow_any_instance_of(User).to receive(:english_score).and_return(8) }

      it 'returns user english_score' do
        expect(subject.english_score).to eq(8)
      end
    end

    context 'when english_score is nil' do
      before { allow_any_instance_of(User).to receive(:english_score).and_return(nil) }

      it 'returns not evaluated' do
        expect(subject.english_score).to eq('Não avaliado')
      end
    end
  end

  describe '#performance_score' do
    subject(:user) { build_stubbed(:user).decorate }

    context 'when performance_score is set' do
      before { allow_any_instance_of(User).to receive(:performance_score).and_return(5) }

      it 'returns user performance_score' do
        expect(subject.performance_score).to eq(5)
      end
    end

    context 'when performance_score is nil' do
      before { allow_any_instance_of(User).to receive(:performance_score).and_return(nil) }

      it 'returns not evaluated' do
        expect(subject.performance_score).to eq('Não avaliado')
      end
    end
  end

  describe '#overall_score' do
    subject(:user) { build_stubbed(:user).decorate }

    context 'when overall_score is set' do
      before { allow_any_instance_of(User).to receive(:overall_score).and_return(2) }

      it 'returns user overall_score' do
        expect(subject.overall_score).to eq(2)
      end
    end

    context 'when overall_score is nil' do
      before { allow_any_instance_of(User).to receive(:overall_score).and_return(nil) }

      it 'returns not evaluated' do
        expect(subject.overall_score).to eq('Não avaliado')
      end
    end
  end
end
