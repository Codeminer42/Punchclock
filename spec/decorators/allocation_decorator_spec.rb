# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllocationDecorator do
  let(:allocation) { build_stubbed(:allocation) }
  let(:decorated) { allocation.decorate }

  describe "#hourly_rate" do
    it "returns the humanized value" do
      humanized_value = helper.humanized_money_with_symbol(allocation.hourly_rate)
      expect(decorated.hourly_rate).to eq(humanized_value)
    end
  end

  describe "#to_s" do
    it "returns the allocation ID" do
      expect(decorated.to_s).to eq("##{allocation.id}")
    end
  end
end
