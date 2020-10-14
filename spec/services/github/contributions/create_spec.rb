# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Create, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#call' do
    subject(:call) { described_class.new(company: company, client: client).call }

    let(:client) { instance_double('Github') }

    context 'when company is not present' do
      let(:company) { nil }

      it { is_expected.to be_empty }
    end

    # TODO: Add specs to cover all use cases
  end
end
