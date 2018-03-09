# frozen_string_literal: true

RSpec.describe RARBG::API do
  before(:all) do
    @rarbg = RARBG::API.new
    @token = SecureRandom.hex(5)
  end

  context 'when token request succeeds' do
    before(:context) do
      stub_request(:get, DEFAULT_URL + 'get_token=get_token')
        .to_return(status: 200, body: { token: @token }.to_json)
      stub_request(:get, DEFAULT_URL + "mode=list&token=#{@token}")
        .to_return(status: 200, body: {}.to_json)

      @rarbg.list
    end

    it 'has a token' do
      expect(@rarbg.token).not_to be nil
    end

    it 'stores the returned token' do
      expect(@rarbg.token).to eq(@token)
    end

    it 'has a token timestamp' do
      expect(@rarbg.token_time).to be_a(Integer)
    end

    it 'has last request > token_time' do
      expect(@rarbg.last_request).to be > @rarbg.token_time
    end
  end

  context 'when token request fails' do
    before(:context) do
      stub_request(:get, /torrentapi.org/)
        .to_return(status: [500, 'Internal Server Error'])
    end

    it 'raises an exception' do
      expect { @rarbg.list }.to raise_error(
        RARBG::APIError, 'Internal Server Error (500)'
      )
    end
  end
end
