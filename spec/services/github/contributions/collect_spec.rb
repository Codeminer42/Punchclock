# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Collect, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#all' do
    subject(:all) { described_class.new(company: company, client: client).all }

    let(:client) { instance_double('Github') }

    context 'when company is not present' do
      let(:company) { nil }

      it { is_expected.to be_empty }
    end

    context 'when there are no repositories in database' do
      let(:company) { build_stubbed(:company) }

      it { is_expected.to be_empty }
    end

    # TODO: Add specs to cover all use cases
  end
end
