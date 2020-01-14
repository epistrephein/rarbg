# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

# Main namespace for RARBG.
module RARBG
  # Default error class for the module. Wraps exceptions raised at API level.
  class APIError < StandardError; end

  # Base class for RARBG API.
  class API
    # RARBG API endpoint.
    API_ENDPOINT = 'https://torrentapi.org/pubapi_v2.php'

    # App name identifier.
    APP_ID = 'rarbg-rubygem'

    # Default token expiration time (seconds).
    TOKEN_EXPIRATION = 800

    # Default API rate limit (seconds).
    RATE_LIMIT = 2.1

    # The underlying `Faraday::Connection` object used to perform requests.
    #
    # @note For more info regarding this object refer to the
    #   {https://www.rubydoc.info/gems/faraday/Faraday Faraday documentation}.
    #
    # @return [Faraday::Connection] The Faraday connection object.
    attr_reader :connection

    # The monotonic timestamp of the last request performed.
    #   Used to comply with the endpoint rate limit based on {RATE_LIMIT}.
    #
    # @return [Float] The monotonic timestamp of the last request performed.
    attr_reader :last_request

    # The token used for authentication.
    #   This is generated and rate limited automatically when calling {#list}
    #   or {#search}, but can also be generated forcefully using {#token!}.
    #
    # @return [String] The token used for authentication.
    attr_reader :token

    # The monotonic timestamp of the token request.
    #   Used to compute the next required token request based on {TOKEN_EXPIRATION}.
    #
    # @return [Float] The monotonic timestamp of the token request.
    attr_reader :token_time

    # Initialize a new instance of `RARBG::API`.
    #
    # @example
    #   rarbg = RARBG::API.new
    def initialize
      @connection = Faraday.new(url: API_ENDPOINT) do |conn|
        conn.request  :json
        conn.response :json, content_type: /\bjson$/
        conn.response :logger if $VERBOSE
        conn.adapter  Faraday.default_adapter

        conn.options.timeout      = 30
        conn.options.open_timeout = 10

        conn.headers[:user_agent] = APP_ID
        conn.params[:app_id]      = APP_ID
      end
    end

    # List torrents.
    #
    # @example List last 100 ranked torrents in `Movies/x264/1080` category
    #   rarbg = RARBG::API.new
    #   rarbg.list(limit: 100, ranked: true, category: [44])
    #
    # @example List torrents with at least 50 seeders
    #   rarbg = RARBG::API.new
    #   rarbg.list(min_seeders: 50)
    #
    # @param params [Hash] A customizable set of parameters.
    #
    # @option params [Array<Integer>] :category Filter results by category.
    # @option params [Symbol] :format Format results.
    #   Accepted values: `:json`, `:json_extended`.
    #   Default: `:json`.
    # @option params [Integer] :limit Limit results number.
    #   Accepted values: `25`, `50`, `100`.
    #   Default: `25`.
    # @option params [Integer] :min_seeders Filter results by minimum seeders.
    # @option params [Integer] :min_leechers Filter results by minimum leechers.
    # @option params [Boolean] :ranked Include/exclude unranked torrents.
    #   Default: `true`.
    # @option params [Symbol] :sort Sort results.
    #   Accepted values: `:last`, `:seeders`, `:leechers`.
    #   Default: `:last`.
    #
    # @return [Array<Hash>] Torrents that match the specified parameters.
    #
    # @raise [ArgumentError] If `params` is not an `Hash`.
    # @raise [RARBG::APIError] If the request fails or the endpoint responds
    #   with an error.
    # @raise [Faraday::Error] On low-level connection errors (e.g. timeouts).
    def list(params = {})
      raise ArgumentError, 'Expected params hash' unless params.is_a?(Hash)

      params.update(
        mode:  'list',
        token: token?
      )
      call(params)
    end

    # Search torrents.
    #
    # @example Search by IMDb ID, sorted by leechers and in extended format.
    #   rarbg = RARBG::API.new
    #   rarbg.search(imdb: 'tt2488496', sort: :leechers, format: :json_extended)
    #
    # @example Search unranked torrents by string, with at least 2 seeders.
    #   rarbg = RARBG::API.new
    #   rarbg.search(string: 'Star Wars', ranked: false, min_seeders: 2)
    #
    # @param params [Hash] A customizable set of parameters.
    #
    # @option params [String] :string Search by string.
    # @option params [String] :imdb Search by IMDb id.
    # @option params [String] :tvdb Search by TVDB id.
    # @option params [String] :themoviedb Search by The Movie DB id.
    # @option params [Array<Integer>] :category Filter results by category.
    # @option params [Symbol] :format Format results.
    #   Accepted values: `:json`, `:json_extended`.
    #   Default: `:json`.
    # @option params [Integer] :limit Limit results number.
    #   Accepted values: `25`, `50`, `100`.
    #   Default: `25`.
    # @option params [Integer] :min_seeders Filter results by minimum seeders.
    # @option params [Integer] :min_leechers Filter results by minimum leechers.
    # @option params [Boolean] :ranked Include/exclude unranked torrents.
    #   Default: `true`.
    # @option params [Symbol] :sort Sort results.
    #   Accepted values: `:last`, `:seeders`, `:leechers`.
    #   Default: `:last`.
    #
    # @return [Array<Hash>] Torrents that match the specified parameters.
    #
    # @raise [ArgumentError] If `params` is not an `Hash`.
    # @raise [ArgumentError] If no search type param is passed
    #   (among `string`, `imdb`, `tvdb`, `themoviedb`).
    # @raise [RARBG::APIError] If the request fails or the endpoint responds
    #   with an error.
    # @raise [Faraday::Error] On low-level connection errors (e.g. timeouts).
    def search(params = {})
      raise ArgumentError, 'Expected params hash' unless params.is_a?(Hash)

      params.update(
        mode:  'search',
        token: token?
      )
      call(params)
    end

    # Generate the authentication token.
    #
    # @example Generate the token immediately after object instantiation.
    #   rarbg = RARBG::API.new
    #   rarbg.token!
    #
    # @return [String] The currently valid authentication token.
    def token!
      token?
    end

    private

    # Supported search parameters.
    SEARCH_KEYS = %w[string imdb tvdb themoviedb].freeze
    private_constant :SEARCH_KEYS

    # Endpoint error strings to return as no results.
    NO_RESULTS_ERRORS_REGEXPS = Regexp.union([
      /no results found/i,
      /can'?t find .+? in database/i
    ])
    private_constant :NO_RESULTS_ERRORS_REGEXPS

    # Wrap requests for error handling.
    def call(params)
      response = request(validate(params))

      return [] if response['error'] =~ NO_RESULTS_ERRORS_REGEXPS
      raise APIError, response['error'] if response.key?('error')

      response.fetch('torrent_results', [])
    end

    # Validate parameters.
    def validate(params)
      params = stringify(params)
      params = validate_search!(params) if params['mode'] == 'search'

      normalize.each_pair do |key, proc|
        params[key] = proc.call(params[key]) if params.key?(key)
      end
      params
    end

    # Convert symbol keys to string and remove nil values.
    def stringify(params)
      Hash[params.reject { |_k, v| v.nil? }.map { |k, v| [k.to_s, v] }]
    end

    # Validate search type parameters.
    def validate_search!(params)
      if (params.keys & SEARCH_KEYS).none?
        raise(ArgumentError,
              "One search parameter required among: #{SEARCH_KEYS.join(', ')}")
      end

      SEARCH_KEYS.each do |k|
        params["search_#{k}"] = params.delete(k) if params.key?(k)
      end
      params
    end

    # Convert ruby syntax to expected value format.
    def normalize
      {
        'category'    => (->(v) { v.join(';') }),
        'ranked'      => (->(v) { v == false ? 0 : 1 }),
        'search_imdb' => (->(v) { v.to_s[/^tt/] ? v.to_s : "tt#{v}" })
      }
    end

    # Return or renew auth token.
    def token?
      if token.nil? || time >= (token_time.to_f + TOKEN_EXPIRATION)
        response = request(get_token: 'get_token')
        @token = response.fetch('token')
        @token_time = time
      end
      token
    end

    # Perform API request.
    def request(params)
      rate_limit!(RATE_LIMIT)
      response = connection.get(nil, params)
      @last_request = time

      return response.body if response.success?

      raise APIError, "#{response.reason_phrase} (#{response.status})"
    end

    # Rate-limit requests to comply with endpoint limits.
    def rate_limit!(seconds)
      sleep(0.1) until time >= (last_request.to_f + seconds)
    end

    # Monotonic clock for elapsed time calculations.
    def time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
