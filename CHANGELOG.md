# Changelog

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## Unreleased
[Diff](https://github.com/epistrephein/rarbg/compare/v1.3.0...master)

#### Fixed
- Fix typos and code style here and there.

#### Changed
- Allow any Bundler version equal or greater than 1.15 ([#9](https://github.com/epistrephein/rarbg/pull/9)).


## 1.3.0 - 2019-02-07
[RubyGems](https://rubygems.org/gems/rarbg/versions/1.3.0) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v1.3.0) |
[Diff](https://github.com/epistrephein/rarbg/compare/v1.2.0...v1.3.0)

#### Fixed
- Return an empty array when endpoint responds with a `Can't find` error on
`imdb`/`themoviedb`/`tvdb` search ([#6](https://github.com/epistrephein/rarbg/pull/6)).
- Parse JSON only for responses with `application/json` Content-Type, preventing
error responses to raise a `ParsingError` ([#4](https://github.com/epistrephein/rarbg/pull/4)).

#### Added
- Add `token!` public method for standalone token generation
([#3](https://github.com/epistrephein/rarbg/pull/3)).

#### Changed
- Reduce Faraday connection timeout to 30 seconds.


## 1.2.0 - 2019-01-02
[RubyGems](https://rubygems.org/gems/rarbg/versions/1.2.0) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v1.2.0) |
[Diff](https://github.com/epistrephein/rarbg/compare/v1.1.1...v1.2.0)

#### Fixed
- Fixed gemspec to not include HTML documentation files.
- Fixed code style and typos.

#### Added
- Added rubocop as development dependency to enforce code style.
- Added GitHub templates for issues and pull requests.
- Added CONTRIBUTING document with contribution guidelines.

#### Changed
- Bumped all dependencies to stricter minor version constraint.
- Rate limit is now stubbed to 0.1 seconds in RSpec to speed up tests.


## 1.1.1 - 2018-10-19
[RubyGems](https://rubygems.org/gems/rarbg/versions/1.1.1) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v1.1.1) |
[Diff](https://github.com/epistrephein/rarbg/compare/v1.1.0...v1.1.1)

#### Changed
- Self-host documentation on GitHub pages.


## 1.1.0 - 2018-10-05
[RubyGems](https://rubygems.org/gems/rarbg/versions/1.1.0) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v1.1.0) |
[Diff](https://github.com/epistrephein/rarbg/compare/v1.0.1...v1.1.0)

#### Added
- `list` and `search` methods are now available from top level namespace.
- `RARBG::CATEGORIES` now returns name/id pairs of all RARBG categories.
- Faraday now uses the `APP_ID` as User agent.


## 1.0.1 - 2018-05-04
[RubyGems](https://rubygems.org/gems/rarbg/versions/1.0.1) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v1.0.1) |
[Diff](https://github.com/epistrephein/rarbg/compare/v1.0.0...v1.0.1)

#### Fixed
- Fixed code styling and some documentation errors.
- Fixed IMDb id autocorrect in `search`.

#### Added
- Faraday now logs requests to stdout if in verbose mode (`-w` or `-v`).


## 1.0.0 – 2018-04-02
[RubyGems](https://rubygems.org/gems/rarbg/versions/1.0.0) |
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
[RubyGems](https://rubygems.org/gems/rarbg/versions/0.1.4) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.4) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.3...v0.1.4)

#### Fixed
- Set Faraday middleware before adapter to suppress warning.


## 0.1.3 – 2016-12-23
[RubyGems](https://rubygems.org/gems/rarbg/versions/0.1.3) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.3) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.2...v0.1.3)

#### Changed
- Move `app_id` and `token` params to `call` method to prevent override.


## 0.1.2 – 2016-12-21
[RubyGems](https://rubygems.org/gems/rarbg/versions/0.1.2) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.2) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.1...v0.1.2)

#### Changed
- Sleep for 2 seconds after `get_token` to avoid request limit error.


## 0.1.1 – 2016-12-21
[RubyGems](https://rubygems.org/gems/rarbg/versions/0.1.1) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.1) |
[Diff](https://github.com/epistrephein/rarbg/compare/v0.1.0...v0.1.1)

#### Fixed
- Fix invalid gemspec.


## 0.1.0 – 2016-12-21
[RubyGems](https://rubygems.org/gems/rarbg/versions/0.1.0) |
[Release](https://github.com/epistrephein/rarbg/releases/tag/v0.1.0)

Initial release. Yanked from RubyGems.
