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


## Usage

This gem wraps all API methods available from torrentapi which are documented [here](https://torrentapi.org/apidocs_v2.txt).

Authentication token is automatically generated on first request, stored with timestamp and renewed every 800 seconds.

#### Getting started

Require the gem and initialize a new `RARBG::API` object.

```ruby
require 'rarbg'
rarbg = RARBG::API.new
```

#### Parameters

All API calls are performed with parameters defined in `@default_params` unless you override them within a single call. Therefore, if you want all API calls to always pass a specific parameter, you can customize the `@default_params` variable.

```ruby
rarbg.default_params
# => {"limit"=>25, "sort"=>"last", "format"=>"json_extended"}

rarbg.default_params['limit'] = 100
rarbg.default_params['sort'] = 'seeders'
rarbg.default_params['min_seeders'] = 10

rarbg.default_params
# => {"limit"=>100, "sort"=>"seeders", "format"=>"json_extended", "min_seeders"=>10}
```

Default parameters can also be set at initialization time.

```ruby
rarbg = RARBG::API.new('limit' => 50)
rarbg.default_params
# => {"limit"=>50, "sort"=>"last", "format"=>"json_extended"}
```

#### Methods

All successful method calls return an array of hashes. By default, `json_extended` is passed as format parameter to get more details regarding a torrent.

Use `#list` to list torrents

```ruby
rarbg.list
```

Use `#search_string` to perform a literal search.

```ruby
rarbg.search_string('Force Awakens')
```

Use `#search_imdb`, `#search_themoviedb`, `#search_tvdb` to perform search using respective ids.

```ruby
rarbg.search_imdb('tt2488496')
rarbg.search_themoviedb(140607)
rarbg.search_tvdb(81189)
```

Note that `tt` can be omitted when passing an IMDB id as it will be automatically prepended if missing. 

Parameters can be passed to any call, and will override defaults if conflicting.

```ruby
rarbg.search_string('Force Awakens', 'limit' => 100, 'min_seeders' => 30, 'category' => 42)

rarbg.search_imdb(
  2488496,
  'category' => '44;45',
  'sort' => 'seeders',
  'ranked' => 0,
  'format' => 'json'
)
```
#### Errors

Any API error will raise a `RARBG::APIError` exception with the API error message.

```ruby
rarbg.list
# RARBG::APIError: Too many requests per second. Maximum requests allowed are 1req/2sec Please try again later!

rarbg.search_string('thisisdefinitelyawrongquery')
# RARBG::APIError: No results found

rarbg.search_string('Force Awakens', 'min_seeders' => 'notanumber')
# RARBG::APIError: Invalid value for min_seeders
```

Any request error, will raise either `Faraday::Error` and its subclasses at low level or `RARBG::RequestError` with request error message at higher level.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/epistrephein/rarbg).

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Code of Conduct](CODE_OF_CONDUCT.md).

## License
This gem is released as open source under the terms of the [MIT License](LICENSE).
