<div align="center">
  <h1>RARBG</h1>

  <p>Ruby client for the RARBG Torrent API</p>

  <p>
    <a href="https://rubygems.org/gems/rarbg">RubyGems</a> —
    <a href="https://epistrephein.github.io/rarbg/">Documentation</a>
  </p>
</div>

## Installation

Install as a gem

```shell
$ gem install rarbg
```

Or add it to your Gemfile and execute `bundle install`

```ruby
gem 'rarbg', '~> 2.0'
```

## Usage

This gem wraps all API methods available from [RARBG TorrentAPI](https://torrentapi.org/apidocs_v2.txt?app_id=rarbg-rubygem).

An authentication token is automatically generated on the first request, stored with a timestamp and renewed every 800 seconds.

Rate limit (1req/2s) is automatically enforced.

Check out the [full documentation](https://epistrephein.github.io/rarbg) for details on all methods and parameters.

#### Getting started

Require the gem and initialize a new `RARBG::API` object.

```ruby
require 'rarbg'

rarbg = RARBG::API.new
```

#### Methods

Use [`list`](https://epistrephein.github.io/rarbg/RARBG/API.html#list-instance_method) to list torrents.
Additional parameters are passed as keyword arguments and can be mixed together.

All successful method calls return an array of hashes (or an empty array for no results).

```ruby
# List last 100 torrents.
rarbg.list(limit: 100)

# List torrents with at least 20 seeders, sorted by seeders.
rarbg.list(min_seeders: 20, sort: :seeders)

# List torrents with extended json infos.
rarbg.list(format: :json_extended)
```

Use [`search`](https://epistrephein.github.io/rarbg/RARBG/API.html#search-instance_method) to search torrents.
One search type parameter among `string`, `imdb`, `themoviedb` and `tvdb` is required.

```ruby
# Search torrents using literal string query.
rarbg.search(string: 'Force Awakens')

# Search by IMDB id, in `Movies/x264/1080` and `Movies/x264/720`.
rarbg.search(imdb: 'tt2488496', category: [44, 45])

# Search unranked torrents by TheMovieDB id, sorted by last.
rarbg.search(themoviedb: 140607, ranked: false, sort: :last)
```

These methods are also available from the top module namespace for convenience.

```ruby
RARBG.list(sort: :leechers, min_leechers: 10)

RARBG.search(string: 'Star Wars', category: [48])
```

A list of name/id pairs for each category is available for quick lookup.

```ruby
RARBG::CATEGORIES
# => { "Movies/XVID"     => 14,
#      "Movies/XVID/720" => 48,
#      "Movies/x264"     => 17,
#      ...
```

#### Errors

API endpoint errors will raise a `RARBG::APIError` exception with the API error message.

```ruby
rarbg.list(sort: :name)
# => RARBG::APIError: Invalid sort

rarbg.search(string: 'Star Wars', min_seeders: 'notanumber')
# => RARBG::APIError: Invalid value for min_seeders

rarbg.search(imdb: 'tt0121765')
# => RARBG::APIError: Service unavailable (503)
```

Parameter validation errors on client side will raise an `ArgumentError`.

```ruby
rarbg.list('a string instead of an hash')
# => ArgumentError: Expected params hash

rarbg.search(limit: 50)
# => ArgumentError: One search parameter required among: string, imdb, tvdb, themoviedb
```

Lower level connection errors will raise `Faraday::Error` subclasses exceptions.

```ruby
rarbg.search(string: 'a timeout error')
# => Faraday::ConnectionFailed: execution expired
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/epistrephein/rarbg).

This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [Code of Conduct](https://github.com/epistrephein/rarbg/blob/master/CODE_OF_CONDUCT.md).

You can contribute changes by forking the project and submitting a pull request. To get started:

1. Fork the repo
2. Install the dependencies (`bin/setup`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Pass the test suite (`rake spec`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new pull request

For more information about contributing to this project, check out [CONTRIBUTING](https://github.com/epistrephein/rarbg/blob/master/CONTRIBUTING.md).

## License

This gem is released as open source under the terms of the [MIT License](https://github.com/epistrephein/rarbg/blob/master/LICENSE).
