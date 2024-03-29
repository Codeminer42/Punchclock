# To include this example you must provide an authentication token into the "headers"
# attributes.
#
# Example:
#   let(:headers) { { token: user.token } }
RSpec.shared_examples 'an authenticated resource action' do
  it 'returns content type json' do
    expect(subject.content_type).to eq 'application/json; charset=utf-8'
  end
end

RSpec.shared_examples 'an authenticated create resource action' do
  it { is_expected.to have_http_status(:created) }

  it 'returns content type json' do
    expect(subject.content_type).to eq 'application/json; charset=utf-8'
  end
end

RSpec.shared_examples 'an unprocessable entity error' do
  it { is_expected.to have_http_status(:unprocessable_entity) }

  it 'returns content type json' do
    expect(subject.content_type).to eq 'application/json; charset=utf-8'
  end
end

RSpec.shared_examples 'an unauthenticated resource action' do
  it { is_expected.to have_http_status(:unauthorized) }

  it 'returns content type json' do
    expect(subject.content_type).to eq 'application/json; charset=utf-8'
  end

  it 'returns a unauthorized message' do
    expect(JSON.parse(subject.body)).to eq('error'=>'unauthorized')
  end
end
