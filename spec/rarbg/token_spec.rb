# frozen_string_literal: true

RSpec.describe RARBG::API do
  before(:all) do
    @rarbg = RARBG::API.new
    @token = SecureRandom.hex(5)
  end

  context 'when token request succeeds' do
    before(:each) do
      stub_token(@token)
      stub_list(@token)
      @rarbg.list
    end

    it 'has a token' do
      expect(@rarbg.token).not_to be nil
    end

    it 'stores the returned token' do
      expect(@rarbg.token).to eq(@token)
    end

    it 'has a token timestamp' do
      expect(@rarbg.token_time).to be_a(Numeric)
    end

    it 'respects rate limit' do
      expect(@rarbg.last_request - @rarbg.token_time).to be >= RARBG::API::RATE_LIMIT
    end
  end

  context 'when token request fails' do
    before(:example) do
      stub_error(500, 'Internal Server Error')
    end

    it 'raises a RARBG::APIError exception' do
      expect { @rarbg.list }.to raise_error(
        RARBG::APIError, 'Internal Server Error (500)'
      )
    end
  end

  context 'when token request timeouts' do
    before(:example) do
      stub_timeout
    end

    it 'raises a Faraday::ConnectionFailed exception' do
      expect { @rarbg.list }.to raise_error(Faraday::ConnectionFailed)
    end
  end

  context 'when forcing the token generation' do
    before(:example) do
      stub_token(
        @token
      )
    end

    it 'returns the currently valid token' do
      expect(@rarbg.token!).to eq(@token)
    end

    context 'when called from top level namespace' do
      let(:rarbg_module) { RARBG.clone }

      it 'instantiates an API object' do
        expect { rarbg_module.token! }
          .to change { rarbg_module.instance_variable_get(:@rarbg).class }
          .to(RARBG::API)
      end
    end
  end
end
