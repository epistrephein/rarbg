# RARBG
[![Gem Version](https://img.shields.io/gem/v/rarbg.svg?colorB=brightgreen&style=flat-square)](https://rubygems.org/gems/rarbg)
[![Build status](https://img.shields.io/travis/epistrephein/rarbg/master.svg?style=flat-square)](https://travis-ci.org/epistrephein/rarbg)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/epistrephein/rarbg.svg?style=flat-square)](https://codeclimate.com/github/epistrephein/rarbg)
[![Coverage](https://img.shields.io/codeclimate/c/epistrephein/rarbg.svg?style=flat-square)](https://codeclimate.com/github/epistrephein/rarbg)
[![Dependency Status](https://img.shields.io/gemnasium/epistrephein/rarbg.svg?style=flat-square)](https://gemnasium.com/epistrephein/rarbg)
[![Inline docs](http://inch-ci.org/github/epistrephein/rarbg.svg?branch=master&style=flat-square)](http://inch-ci.org/github/epistrephein/rarbg)

Ruby wrapper for RARBG Torrent API.

## Installation

Install as a gem

```shell
$ gem install rarbg
```

Or add it to your Gemfile and execute `bundle install`

```ruby
gem 'rarbg', '~> 1.0'
```

## Usage [![Documentation](https://img.shields.io/badge/docs-yard-blue.svg?style=flat-square)](http://www.rubydoc.info/gems/rarbg)

This gem wraps all API methods available from [RARBG TorrentAPI](https://torrentapi.org/apidocs_v2.txt).

An authentication token is automatically generated on first request, stored with timestamp and renewed every 800 seconds.

#### Getting started

Require the gem and initialize a new `RARBG::API` object.

```ruby
require 'rarbg'

rarbg = RARBG::API.new
```

#### Methods

Use `list` to list torrents.
Additional parameters are passed as keyword arguments and can be mixed together.

All successful method calls return an array of hashes.

```ruby
# List last 100 torrents.
rarbg.list(limit: 100)

# List all torrents with at least 20 seeders, sorted by seeders.
rarbg.list(min_seeders: 100, sort: :seeders)

# List torrents with extended json infos.
rarbg.list(format: :json_extended)
```

Use `search` to search torrents.
One search type parameter among `string`, `imdb`, `themoviedb` and `tvdb` is required.

```ruby
# Search torrents using literal string query.
rarbg.search(string: 'Force Awakens')

# Search by IMDB id, in `Movies/x264/1080` and `Movies/x264/720`.
# Note that 'tt' can be omitted when passing an IMDB id.
rarbg.search(imdb: 'tt2488496', category: [44, 45])

# Search unranked torrents by TheMovieDB id, sorted by last.
rarbg.search(themoviedb: 140607, ranked: false, sort: :last)
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
# => ArgumentError: At least one parameter required among string, imdb, tvdb, themoviedb for search mode.
```

## Contributing [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-blue.svg?style=flat-square)](http://makeapullrequest.com)

Bug reports and pull requests are welcome on [GitHub](https://github.com/epistrephein/rarbg).

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Code of Conduct](CODE_OF_CONDUCT.md).

You can contribute changes by forking the project and submitting a pull request. To get started:

1. Fork the repo
2. Install the dependencies (`bin/setup`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Pass the test suite (`rake spec`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new pull request

## License [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
This gem is released as open source under the terms of the [MIT License](LICENSE).
