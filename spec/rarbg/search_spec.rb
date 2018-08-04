# frozen_string_literal: true

RSpec.describe RARBG::API do
  before(:all) do
    @rarbg = RARBG::API.new
    @token = SecureRandom.hex(5)
  end

  before(:each) do
    stub_token(@token)
  end

  context 'when search request succeeds' do
    before(:example) do
      stub_search(
        @token, {},
        { torrent_results: [
          {
            filename: 'first stubbed name',
            category: 'first stubbed category',
            download: 'first stubbed magnet link'
          },
          {
            filename: 'second stubbed name',
            category: 'second stubbed category',
            download: 'second stubbed magnet link'
          }
        ] }
      )
    end

    it 'returns an array of hashes' do
      expect(@rarbg.search(string: 'a search string')).to all(be_an(Hash))
    end

    it 'returns hashes with filename and download link' do
      expect(@rarbg.search(imdb: 'tt0000000'))
        .to all include('filename').and include('download')
    end
  end

  context 'when search request returns no result' do
    before(:example) do
      stub_search(
        @token, {},
        { error: 'No results found' }
      )
    end

    it 'returns an empty array' do
      expect(@rarbg.search(string: 'awrongquery')).to eq([])
    end
  end

  context 'when search request parameters is not an hash' do
    before(:example) do
      stub_search(
        @token
      )
    end

    it 'raises an ArgumentError exception' do
      expect { @rarbg.search('string') }.to raise_error(
        ArgumentError, 'Expected params hash'
      )
    end
  end

  context 'when search request is missing search type' do
    before(:example) do
      stub_search(
        @token
      )
    end

    it 'raises an ArgumentError exception' do
      expect { @rarbg.search(category: [45, 46], sort: :last) }
        .to raise_error(ArgumentError)
    end
  end

  context 'when search request has invalid parameters' do
    before(:example) do
      stub_search(
        @token, {},
        { error: 'Invalid sort' }
      )
    end

    it 'raises a RARBG::APIError exception' do
      expect { @rarbg.search(string: 'string', sort: 'wrongsort') }
        .to raise_error(RARBG::APIError, 'Invalid sort')
    end
  end

  context 'when search request fails' do
    before(:example) do
      stub_error(503, 'Service unavailable')
    end

    it 'raises a RARBG::APIError exception' do
      expect { @rarbg.search(string: 'string') }.to raise_error(
        RARBG::APIError, 'Service unavailable (503)'
      )
    end
  end
end
