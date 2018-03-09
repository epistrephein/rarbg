# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

# Main namespace for RARBG
module RARBG
  # Gem version
  VERSION = '1.0.0.beta.1'

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

    # @return [Integer] the epoch timestamp of the token request.
    attr_reader :token_time

    # @return [Integer] the epoch timestamp of the last request performed.
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

        conn.params[:app_id] = APP_ID
      end
    end

    # List torrents.
    #
    # @param params [Hash] A customizable set of parameters.
    #
    # @option params [Array<Integer>] :category
    # @option params [Symbol] :format Results format.
    #   Valid values: `:json`, `:json_extended`. Default: `:json`.
    # @option params [Integer] :limit Results limit.
    #   Valid values: `25`, `50`, `100`. Default: `25`.
    # @option params [Integer] :min_seeders
    # @option params [Integer] :min_leechers
    # @option params [Boolean] :ranked
    # @option params [Symbol] :sort Results sorting.
    #   Valid values: `:last`, `:seeders`, `:leechers`. Default: `:last`.
    #
    # @return [Array<Hash>] Return tweets that match a specified query with
    #   search metadata.
    #
    # @raise [RARBG::APIError] Error raised when supplied user credentials
    #   are not valid.
    #
    # @example List last 100 ranked torrents in `Movies/x264/1080`
    #   rarbg = RARBG::API.new
    #   rarbg.list(limit: 100, ranked: true, category: [44])
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
    # @option params [String] :string
    # @option params [String] :imdb
    # @option params [String] :tvdb
    # @option params [String] :themoviedb
    # @option params [Array<Integer>] :category
    # @option params [Symbol] :format
    # @option params [Integer] :limit
    # @option params [Integer] :min_seeders
    # @option params [Integer] :min_leechers
    # @option params [Boolean] :ranked
    # @option params [Symbol] :sort
    #   Valid values: `:last`, `:seeders`, `:leechers`. Default: `:last`.
    #
    # @return [Array<Hash>] Return tweets that match a specified query with
    #   search metadata.
    #
    # @raise [RARBG::APIError] Error raised when supplied user credentials
    #   are not valid.
    #
    # @example Search by IMDb ID, sorted by leechers.
    #   rarbg = RARBG::API.new
    #   rarbg.search(imdb: 'tt012831', sort: :leechers)
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

    def call(params)
      response = request(validate(params))

      return [] if response['error'] == 'No results found'
      raise APIError, response['error'] if response.key?('error')
      response.fetch('torrent_results', [])
    end

    def validate(params)
      params = stringify(params)
      params = validate_search!(params) if params['mode'] == 'search'

      normalize.each_pair do |key, proc|
        params[key] = proc.call(params[key]) if params.key?(key)
      end
      params
    end

    def stringify(params)
      Hash[params.reject { |_k, v| v.nil? }.map { |k, v| [k.to_s, v] }]
    end

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

    def normalize
      {
        'category' => (->(v) { v.join(';') }),
        'imdb'     => (->(v) { v.to_s[/^tt/] ? v.to_s : "tt#{v}" }),
        'ranked'   => (->(v) { v == false ? 0 : 1 })
      }
    end

    def token?
      if @token.nil? || Time.now.to_i >= (@token_time + TOKEN_EXPIRATION)
        response = request(get_token: 'get_token')
        @token = response.fetch('token')
        @token_time = Time.now.to_i
      end
      @token
    end

    def request(params)
      rate_limit!(2.5)

      response = @conn.get(nil, params)
      @last_request = Time.now.to_i

      return response.body if response.success?
      raise APIError, "#{response.reason_phrase} (#{response.status})"
    end

    def rate_limit!(seconds)
      sleep(0.5) until Time.now.to_f >= (@last_request.to_i + seconds)
    end
  end
end
