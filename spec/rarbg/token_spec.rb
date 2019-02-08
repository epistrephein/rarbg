# frozen_string_literal: true

RSpec.describe RARBG::API do
  let(:cassette) { 'token/200' }
  let(:subject) { RARBG::API.new }
  let(:token!) do
    VCR.use_cassette(cassette) {
      subject.token!
    }
  end

  context 'when token request succeeds' do
    it 'stores the returned token' do
      expect { token! }
        .to change { subject.token }
        .from(nil).to(String)
    end

    it 'stores the token timestamp' do
      expect { token! }
        .to change { subject.token_time }
        .from(nil).to(Numeric)
    end

    it 'stores the last request timestamp' do
      expect { token! }
        .to change { subject.last_request }
        .from(nil).to(Numeric)
    end
  end

  context 'when token request fails' do
    let(:cassette) { 'token/500' }

    it 'raises a RARBG::APIError exception' do
      expect { token! }.to raise_error(
        RARBG::APIError, 'Internal Server Error (500)'
      )
    end
  end

  context 'when token request timeouts' do
    before(:example) do
      stub_request(:get, RARBG::API::API_ENDPOINT)
        .with(query: hash_including({}))
        .to_timeout
    end

    it 'raises a Faraday::ConnectionFailed exception' do
      expect { token! }.to raise_error(Faraday::ConnectionFailed)
    end
  end
end
