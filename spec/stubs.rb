# frozen_string_literal: true

module Stubs
  BASE_URL = 'https://torrentapi.org/pubapi_v2.php'
  APP_ID   = 'rarbg-rubygem'

  def stub_token(token)
    stub_request(:get, BASE_URL)
      .with(query: hash_including('get_token' => 'get_token'))
      .to_return(status: 200, body: { token: token }.to_json)
  end

  def stub_list(token, params = {}, result = {})
    stub_request(:get, BASE_URL)
      .with(query: hash_including(params.update(
        mode:  'list',
        token: token
      )))
      .to_return(status: 200, body: result.to_json)
  end

  def stub_search(token, params = {}, result = {})
    stub_request(:get, BASE_URL)
      .with(query: hash_including(params.update(
        mode:  'search',
        token: token
      )))
      .to_return(status: 200, body: result.to_json)
  end

  def stub_server_error(status, error)
    stub_request(:get, BASE_URL)
      .with(query: hash_including({}))
      .to_return(status: [status, error])
  end

  def stub_timeout
    stub_request(:get, BASE_URL)
      .with(query: hash_including({}))
      .to_timeout
  end
end
