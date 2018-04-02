# Changelog

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 1.0.0 – 2018-04-02
[Release](https://github.com/epistrephein/rarbg/releases/tag/v1.0.0) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.4...v1.0.0)

#### Changed
- Codebase has been completely refactored to be more resilient and error-free.
- This release is NOT backward compatible with 0.1 versions.
- Query parameters now use standard ruby syntax as expected and accept both
symbol and string keys.
- Compliance with API rate limiting (1req/2s) is now enforced automatically.
- Empty results now return an empty array instead of raising an exception.

#### Removed
- Removed `default_params`: query parameters are now passed per request.
- Removed `search_string`, `search_imdb`, `search_themoviedb`, `search_tvdb`:
search type must be specified as a keyword argument upon `search`.
- Removed `RequestError` exception: all API-related errors now raise an
`APIError` exception.


## 0.1.4 – 2017-12-22
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.4) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.3...v0.1.4)

#### Fixed
- Set Faraday middleware before adapter to suppress warning


## 0.1.3 – 2016-12-23
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.3) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.2...v0.1.3)

#### Changed
- Move `app_id` and `token` params to `call` method to prevent override


## 0.1.2 – 2016-12-21
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.2) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.1...v0.1.2)

#### Changed
- Sleep for 2 seconds after `get_token` to avoid request limit error


## 0.1.1 – 2016-12-21
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.1) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.0...v0.1.1)

#### Fixed
- Fix invalid gemspec


## 0.1.0 – 2016-12-21

Yanked
