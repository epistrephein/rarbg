# frozen_string_literal: true

RSpec.describe RARBG::API do
  before(:all) do
    @rarbg = RARBG::API.new
    @token = SecureRandom.hex(5)
  end

  before(:each) do
    stub_token(@token)
  end

  context 'when list request succeeds' do
    before(:example) do
      stub_list(
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

    it 'returns and array of hashes' do
      expect(@rarbg.list).to all(be_an(Hash))
    end

    it 'returns hashes with filename and download link' do
      expect(@rarbg.list).to all(include('filename').and include('download'))
    end
  end

  context 'when list request returns no result' do
    before(:example) do
      stub_list(
        @token, {},
        { error: 'No results found' }
      )
    end

    it 'returns an empty array' do
      expect(@rarbg.list).to eq([])
    end
  end

  context 'when list request parameters is not an hash' do
    before(:example) do
      stub_list(
        @token
      )
    end

    it 'raises an ArgumentError exception' do
      expect { @rarbg.list('string') }.to raise_error(
        ArgumentError, 'Expected params hash'
      )
    end
  end

  context 'when list request has invalid parameters' do
    before(:example) do
      stub_list(
        @token,
        { min_seeders: 'string' },
        { error: 'Invalid value for min_seeders' }
      )
    end

    it 'raises an APIError exception' do
      expect { @rarbg.list(min_seeders: 'string') }.to raise_error(
        RARBG::APIError, 'Invalid value for min_seeders'
      )
    end
  end

  context 'when list request fails' do
    before(:example) do
      stub_error(500, 'Internal Server Error')
    end

    it 'raises an APIError exception' do
      expect { @rarbg.list }.to raise_error(
        RARBG::APIError, 'Internal Server Error (500)'
      )
    end
  end
end
