# frozen_string_literal: true

RSpec.describe 'RARBG::API#search' do
  let(:cassette) { 'search/200' }
  let(:subject) { RARBG::API.new }
  let(:params) { { string: 'Rogue One' } }
  let(:search) do
    VCR.use_cassette(cassette) {
      subject.search(params)
    }
  end

  context 'when search request succeeds' do
    it 'returns an array of hashes' do
      expect(search).to all(be_an(Hash))
    end

    it 'returns hashes with filename and download link' do
      expect(search).to all include('filename').and include('download')
    end
  end

  context 'when search request returns no result' do
    let(:params) { { string: 'awrongquery' } }

    it 'returns an empty array' do
      expect(search).to eq([])
    end
  end

  context 'when search request returns an id error' do
    let(:params) { { themoviedb: '999999' } }

    it 'returns an empty array' do
      expect(search).to eq([])
    end
  end

  context 'when search request parameters is not an hash' do
    let(:params) { 'string' }

    it 'raises an ArgumentError exception' do
      expect { search }.to raise_error(
        ArgumentError, 'Expected params hash'
      )
    end
  end

  context 'when search request is missing search type' do
    let(:params) { { category: [45, 46], sort: :last } }

    it 'raises an ArgumentError exception' do
      expect { search }.to raise_error(ArgumentError)
    end
  end

  context 'when search request has invalid parameters' do
    let(:params) { { string: 'Rogue One', sort: :wrongsort } }

    it 'raises a RARBG::APIError exception' do
      expect { search }.to raise_error(RARBG::APIError, 'Invalid sort')
    end
  end

  context 'when search request fails' do
    let(:cassette) { 'search/503' }

    it 'raises a RARBG::APIError exception' do
      expect { search }.to raise_error(
        RARBG::APIError, 'Service Unavailable (503)'
      )
    end
  end

  context 'when called from top level namespace' do
    let(:subject) { RARBG.clone }
    let(:params) { { string: 'Rogue One' } }

    it 'instantiates an API object' do
      expect { search }
        .to change { subject.instance_variable_get(:@rarbg).class }
        .to(RARBG::API)
    end
  end
end
