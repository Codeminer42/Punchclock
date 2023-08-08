# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::RevenueForecastHelper, type: :helper do
  before do
    klass = Class.new(ApplicationController) do
      include NewAdmin::RevenueForecastHelper
    end

    stub_const('Klass', klass)
  end

  let(:klass) { Klass.new }

  describe '#selector_data_tab_id' do
    it 'returns selector with year' do
      expect(klass.selector_data_tab_id(2025)).to eq('revenue_forecast_2025')
    end
  end

  describe '#international_forecast' do
    it 'returns a Presenter instance' do
      presenter = klass.international_forecast(2025)

      expect(presenter).to be_an_instance_of(RevenueForecastPresenter)
    end
  end

  describe '#internal_forecast' do
    it 'returns a Presenter instance' do
      presenter = klass.internal_forecast(2025)

      expect(presenter).to be_an_instance_of(RevenueForecastPresenter)
    end
  end
end
