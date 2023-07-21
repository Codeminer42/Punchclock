require 'spec_helper'

describe Api::V1::ContributionsController, type: :controller do
  describe 'GET #latest' do
    subject(:request) { get :latest }

    let!(:first_batch_of_received) { create_list(:contribution, 10, :received) }
    let!(:first_batch_of_approved) { create_list(:contribution, 10, :approved) }
    let!(:first_batch_of_refused) { create_list(:contribution, 10, :refused, :other_reason) }
    let!(:second_batch_of_approved) { create_list(:contribution, 10, :approved) }
    let!(:second_batch_of_refused) { create_list(:contribution, 10, :refused, :other_reason) }
    let!(:third_batch_of_approved) { create_list(:contribution, 10, :approved) }
    let!(:second_batch_of_received) { create_list(:contribution, 10, :received) }

    it { is_expected.to have_http_status(:ok) }

    it 'returns content type json' do
      expect(request.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'should not return contributions on received state' do
      (first_batch_of_received + second_batch_of_received).each do |contribution|
        expect(subject.body).not_to include(contribution.link)
      end
    end

    it 'should not return contributions on refused state' do
      (first_batch_of_refused + second_batch_of_refused).each do |contribution|
        expect(subject.body).not_to include(contribution.link)
      end
    end

    it 'returns the last 25 approved contributions' do
      first_batch_of_approved.reverse!
      second_batch_of_approved.reverse!
      third_batch_of_approved.reverse!

      (third_batch_of_approved + second_batch_of_approved + first_batch_of_approved[..4]).each do |contribution|
        expect(subject.body).to include(contribution.link)
      end

      first_batch_of_approved[5..].each do |contribution|
        expect(subject.body).not_to include(contribution.link)
      end
    end

    it 'returns the approved contributions sorted in descending order' do
      response = JSON.parse(subject.body)

      first_batch_of_approved.reverse!
      second_batch_of_approved.reverse!
      third_batch_of_approved.reverse!

      expect(response[2]['link']).to eq(third_batch_of_approved[2].link)
      expect(response[3]['link']).to eq(third_batch_of_approved[3].link)

      expect(response[15]['link']).to eq(second_batch_of_approved[5].link)
      expect(response[16]['link']).to eq(second_batch_of_approved[6].link)

      expect(response[23]['link']).to eq(first_batch_of_approved[3].link)
      expect(response[24]['link']).to eq(first_batch_of_approved[4].link)
    end
  end
end
