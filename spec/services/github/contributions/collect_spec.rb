# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Collect, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#all' do
    subject(:all) { described_class.new(company: company, client: client).all }

    let(:client) { class_double(Github) }

    context 'when company is not present' do
      let(:company) { nil }

      it { is_expected.to be_empty }
    end

    context 'when there are no repositories in database' do
      let(:company) { build_stubbed(:company) }

      it { is_expected.to be_empty }
    end

    context 'when there are no engineers in database' do
      let(:company) { build_stubbed(:company) }
      let(:repositories) { double(pluck: [[1, 'http://example.com']]) }

      before do
        allow(company).to receive(:repositories).and_return(repositories)
      end
      
      it { is_expected.to be_empty }
    end

    context 'when Github API is not able to respond' do
      let(:company) { build_stubbed(:company) }      
      let(:repositories) { double(pluck: [[1, 'http://example.com']]) }
      let(:engineers) { double(active: double(pluck: [['github_user', 1]])) }
      let(:users) { double(engineer: engineers) }

      before do
        allow(company).to receive(:repositories).and_return(repositories)
        allow(company).to receive(:users).and_return(users)
        allow(client).to receive(:search) { raise 'any error' }
      end

      it { expect { subject }.to raise_error  }
    end
  end
end
