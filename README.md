# RARBG

A ruby wrapper for RARBG torrentapi.

## Installation

```bash
gem install rarbg
```

## Usage

This gem exposes all API methods available from torrentapi which are documented [here](https://torrentapi.org/apidocs_v2.txt).

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

Note: `tt` can be omitted when passing an IMDB id as it will be automatically prepended if missing. 

Parameters can be passed to any call, and will override defaults if conflicting.

```ruby
rarbg.search_string('Force Awakens', 'limit' => 100, 'min_seeders' => 30)

rarbg.search_imdb(
  2488496,
  'category' => 44,
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
```

Any request error, will raise either `Faraday::Error` and its subclasses at low level or `RARBG::RequestError` with request error message at higher level.

## Contributing

Contributions are welcome and encouraged. Feel free to open an issue or submit a pull request.

## License
[MIT License](https://github.com/epistrephein/rarbg/blob/master/LICENSE)
