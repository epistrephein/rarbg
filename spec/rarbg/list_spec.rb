# frozen_string_literal: true

RSpec.describe 'RARBG::API#list' do
  let(:cassette) { 'list/200' }
  let(:subject) { RARBG::API.new }
  let(:params) { {} }
  let(:list) do
    VCR.use_cassette(cassette) {
      subject.list(params)
    }
  end

  context 'when performing a list request' do
    it 'generate a token first' do
      expect { list }
        .to change { subject.token }
        .from(nil).to(String)
    end

    it 'respects rate limit' do
      list

      expect(subject.last_request - subject.token_time)
        .to be >= RARBG::API::RATE_LIMIT
    end
  end

  context 'when list request succeeds' do
    it 'returns and array of hashes' do
      expect(list).to all(be_an(Hash))
    end

    it 'returns hashes with filename and download link' do
      expect(list).to all include('filename').and include('download')
    end
  end

  context 'when list request returns no result' do
    let(:params) { { min_seeders: 1_000_000 } }

    it 'returns an empty array' do
      expect(list).to eq([])
    end
  end

  context 'when list request parameters is not an hash' do
    let(:params) { 'string' }

    it 'raises an ArgumentError exception' do
      expect { subject.list('string') }.to raise_error(
        ArgumentError, 'Expected params hash'
      )
    end
  end

  context 'when list request has invalid parameters' do
    let(:params) { { min_seeders: 'string' } }

    it 'raises a RARBG::APIError exception' do
      expect { list }.to raise_error(
        RARBG::APIError, 'Invalid value for min_seeders'
      )
    end
  end

  context 'when list request fails' do
    let(:cassette) { 'list/500' }

    it 'raises a RARBG::APIError exception' do
      expect { list }.to raise_error(
        RARBG::APIError, 'Internal Server Error (500)'
      )
    end
  end

  context 'when called from top level namespace' do
    let(:subject) { RARBG.clone }

    it 'instantiates an API object' do
      expect { list }
        .to change { subject.instance_variable_get(:@rarbg).class }
        .to(RARBG::API)
    end
  end
end
