# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

# Main namespace for RARBG
module RARBG
  # Default error class for the module.
  class APIError < StandardError; end

  # Base class for RARBG API.
  class API
    # RARBG API endpoint.
    API_ENDPOINT = 'https://torrentapi.org/pubapi_v2.php'

    # App name identifier.
    APP_ID = 'rarbg-rubygem'

    # Default token expiration time.
    TOKEN_EXPIRATION = 800

    # @return [Faraday::Connection] the Faraday connection object.
    attr_reader :conn

    # @return [String] the token used for authentication.
    attr_reader :token

    # @return [Integer] the monotonic timestamp of the token request.
    attr_reader :token_time

    # @return [Integer] the monotonic timestamp of the last request performed.
    attr_reader :last_request

    # Initialize a new istance of `RARBG::API`.
    #
    # @example
    #   rarbg = RARBG::API.new
    def initialize
      @conn = Faraday.new(url: API_ENDPOINT) do |conn|
        conn.request  :json
        conn.response :json
        conn.adapter  Faraday.default_adapter

        conn.options.timeout = 90
        conn.options.open_timeout = 10

        conn.params[:app_id] = APP_ID
      end
    end

    # List torrents.
    #
    # @param params [Hash] A customizable set of parameters.
    #
    # @option params [Array<Integer>] :category Filter results by category.
    # @option params [Symbol] :format Format results.
    #   Valid values: `:json`, `:json_extended`. Default: `:json`.
    # @option params [Integer] :limit Limit results number.
    #   Valid values: `25`, `50`, `100`. Default: `25`.
    # @option params [Integer] :min_seeders Filter results by minimum seeders.
    # @option params [Integer] :min_leechers Filter results by minimum leechers.
    # @option params [Boolean] :ranked Include/exclude unranked results.
    # @option params [Symbol] :sort Sort results.
    #   Valid values: `:last`, `:seeders`, `:leechers`. Default: `:last`.
    #
    # @return [Array<Hash>] Return torrents that match the specified parameters.
    #
    # @raise [ArgumentError] Exception raised if `params` is not an `Hash`.
    #
    # @raise [RARBG::APIError] Exception raised when request fails or endpoint
    #   responds with an error.
    #
    # @example List last 100 ranked torrents in `Movies/x264/1080`
    #   rarbg = RARBG::API.new
    #   rarbg.list(limit: 100, ranked: true, category: [44])
    #
    # @example List torrents with at least 50 seeders
    #   rarbg = RARBG::API.new
    #   rarbg.list(min_seeders: 50)
    def list(params = {})
      raise ArgumentError, 'Expected params hash' unless params.is_a?(Hash)

      params.update(
        mode:   'list',
        token:  token?
      )
      call(params)
    end

    # Search torrents.
    #
    # @param params [Hash] A customizable set of parameters.
    #
    # @option params [String] :string Search results by string.
    # @option params [String] :imdb Search results by IMDb id.
    # @option params [String] :tvdb Search results by TVDB id.
    # @option params [String] :themoviedb Search results by The Movie DB id.
    # @option params [Array<Integer>] :category Filter results by category.
    # @option params [Symbol] :format Format results.
    #   Valid values: `:json`, `:json_extended`. Default: `:json`
    # @option params [Integer] :limit Limit results number.
    #   Valid values: `25`, `50`, `100`. Default: `25`.
    # @option params [Integer] :min_seeders Filter results by minimum seeders.
    # @option params [Integer] :min_leechers Filter results by minimum leechers.
    # @option params [Boolean] :ranked Include/exclude unranked results.
    # @option params [Symbol] :sort Sort results.
    #   Valid values: `:last`, `:seeders`, `:leechers`. Default: `:last`.
    #
    # @return [Array<Hash>] Return torrents that match the specified parameters.
    #
    # @raise [ArgumentError] Exception raised if `params` is not an `Hash`.
    #
    # @raise [ArgumentError] Exception raised if no search type param is passed
    #   (among `string`, `imdb`, `tvdb`, `themoviedb`).
    #
    # @raise [RARBG::APIError] Exception raised when request fails or endpoint
    #   responds with an error.
    #
    # @example Search by IMDb ID, sorted by leechers and in extended format.
    #   rarbg = RARBG::API.new
    #   rarbg.search(imdb: 'tt012831', sort: :leechers, format: :json_extended)
    #
    # @example Search unranked torrents by string, with at least 2 seeders.
    #   rarbg = RARBG::API.new
    #   rarbg.search(string: 'Star Wars', ranked: false, min_seeders: 2)
    def search(params = {})
      raise ArgumentError, 'Expected params hash' unless params.is_a?(Hash)

      params.update(
        mode:   'search',
        token:  token?
      )
      call(params)
    end

    private

    # Wrap request for error handling.
    def call(params)
      response = request(validate(params))

      return [] if response['error'] == 'No results found'
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

    # Validate search type parameter.
    def validate_search!(params)
      search_keys = %w[string imdb tvdb themoviedb]

      raise(
        ArgumentError,
        "At least one parameter required among #{search_keys.join(', ')} " \
        'for search mode.'
      ) if (params.keys & search_keys).none?

      search_keys.each do |k|
        params["search_#{k}"] = params.delete(k) if params.key?(k)
      end
      params
    end

    # Convert ruby sugar to expected value style.
    def normalize
      {
        'category' => (->(v) { v.join(';') }),
        'imdb'     => (->(v) { v.to_s[/^tt/] ? v.to_s : "tt#{v}" }),
        'ranked'   => (->(v) { v == false ? 0 : 1 })
      }
    end

    # Return or renew auth token.
    def token?
      if @token.nil? || time >= (@token_time + TOKEN_EXPIRATION)
        response = request(get_token: 'get_token')
        @token = response.fetch('token')
        @token_time = time
      end
      @token
    end

    # Perform API request.
    def request(params)
      rate_limit!(2.1)

      response = @conn.get(nil, params)
      @last_request = time

      return response.body if response.success?
      raise APIError, "#{response.reason_phrase} (#{response.status})"
    end

    # Rate-limit requests to comply with endpoint limits.
    def rate_limit!(seconds)
      sleep(0.3) until time >= ((@last_request || 0) + seconds)
    end

    # Monotonic clock for elapsed time calculations.
    def time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
