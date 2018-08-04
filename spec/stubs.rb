# frozen_string_literal: true

module Stubs
  API_ENDPOINT = RARBG::API::API_ENDPOINT

  def stub_token(token)
    stub_request(:get, API_ENDPOINT)
      .with(query: hash_including('get_token' => 'get_token'))
      .to_return(status: 200, body: { token: token }.to_json)
  end

  def stub_list(token, params = {}, result = {})
    stub_request(:get, API_ENDPOINT)
      .with(query: hash_including(params.update(
        mode:  'list',
        token: token
      )))
      .to_return(status: 200, body: result.to_json)
  end

  def stub_search(token, params = {}, result = {})
    stub_request(:get, API_ENDPOINT)
      .with(query: hash_including(params.update(
        mode:  'search',
        token: token
      )))
      .to_return(status: 200, body: result.to_json)
  end

  def stub_error(status, error)
    stub_request(:get, API_ENDPOINT)
      .with(query: hash_including({}))
      .to_return(status: [status, error])
  end

  def stub_timeout
    stub_request(:get, API_ENDPOINT)
      .with(query: hash_including({}))
      .to_timeout
  end
end
