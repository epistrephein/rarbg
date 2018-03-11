# frozen_string_literal: true

RSpec.describe RARBG::API do
  before(:all) do
    @rarbg = RARBG::API.new
    @token = SecureRandom.hex(5)

    stub_request(:get, /get_token/)
      .to_return(status: 200, body: { token: @token }.to_json)
  end

  context 'when list request succeeds' do
  end

  context 'when list request returns no result' do
    before(:example) do
      stub_request(:get, /mode=list/)
        .to_return(status: 200, body: { error: 'No results found' }.to_json)
    end

    it 'returns an empty array' do
      expect(@rarbg.list).to eq([])
    end
  end

  context 'when list request has invalid parameters' do
    before(:example) do
      stub_request(:get, /mode=list/)
        .to_return(status: 200, body: { error: 'Invalid value for min_seeders' }.to_json)
    end

    it 'raises an exception' do
      expect { @rarbg.list(min_seeders: 'string') }.to raise_error(
        RARBG::APIError, 'Invalid value for min_seeders'
      )
    end
  end

  context 'when list request fails' do
    before(:example) do
      stub_request(:get, /mode=list/)
        .to_return(status: [500, 'Internal Server Error'])
    end

    it 'raises an exception' do
      expect { @rarbg.list }.to raise_error(
        RARBG::APIError, 'Internal Server Error (500)'
      )
    end
  end
end
