# frozen_string_literal: true

RSpec.describe RARBG::API do
  it 'has a version number' do
    expect(RARBG::VERSION).not_to be nil
  end

  it 'has an app id' do
    expect(RARBG::API::APP_ID).not_to be nil
  end

  it 'has the correct API endpoint' do
    expect(RARBG::API::API_ENDPOINT).to eq('https://torrentapi.org/pubapi_v2.php')
  end
end
