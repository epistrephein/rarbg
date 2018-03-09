# frozen_string_literal: true

RSpec.describe RARBG::API do
  before(:all) do
    @rarbg = RARBG::API.new
    @token = SecureRandom.hex(5)

    stub_request(:get, /get_token/)
      .to_return(status: 200, body: { token: @token }.to_json)
  end

  context 'when search request succeeds' do
  end

  context 'when search request returns no result' do
    before(:context) do
      stub_request(:get, /mode=search/)
        .to_return(status: 200, body: { error: 'No results found' }.to_json)
    end

    it 'returns an empty array' do
      expect(@rarbg.search(string: 'awrongquery')).to eq([])
    end
  end

  context 'when search request has invalid parameters' do
    before(:context) do
      stub_request(:get, /mode=search/)
        .to_return(status: 200, body: { error: 'Invalid sort' }.to_json)
    end

    it 'raises an ArgumentError for lack of search type' do
      expect { @rarbg.search(category: [45, 46], sort: :last) }
        .to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError for wrong argument class' do
      expect { @rarbg.search('string') }
      .to raise_error(ArgumentError)
    end

    it 'raises an APIError for invalid param name' do
      expect { @rarbg.search(string: 'string', sort: 'wrongsort') }
        .to raise_error(RARBG::APIError, 'Invalid sort')
    end
  end

  context 'when search request fails' do
    before(:context) do
      stub_request(:get, /mode=search/)
        .to_return(status: [503, 'Service unavailable'])
    end

    it 'raises an exception' do
      expect { @rarbg.search(string: 'string') }.to raise_error(
        RARBG::APIError, 'Service unavailable (503)'
      )
    end
  end
end
