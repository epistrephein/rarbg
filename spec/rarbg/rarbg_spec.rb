# frozen_string_literal: true

RSpec.describe RARBG do
  it 'has a version number' do
    expect(RARBG::VERSION).not_to be nil
    expect(RARBG::VERSION).to match(/(\d+\.)(\d+\.)(\d+)(-?[\S]+)?/)
  end

  it 'has a category list' do
    expect(RARBG::CATEGORIES).to be_kind_of(Hash)
    expect(RARBG::CATEGORIES).to include(/Movies/, /TV/, /Music/)
  end

  it 'has an app id' do
    expect(RARBG::API::APP_ID).not_to be nil
    expect(RARBG::API::APP_ID).to be_kind_of(String)
  end

  it 'has the correct API endpoint' do
    expect(RARBG::API::API_ENDPOINT).to eq('https://torrentapi.org/pubapi_v2.php')
  end

  it 'has a token expiration' do
    expect(RARBG::API::TOKEN_EXPIRATION).to be_kind_of(Numeric)
  end

  it 'has a rate limit' do
    expect(RARBG::API::RATE_LIMIT).to be_kind_of(Numeric)
  end
end
