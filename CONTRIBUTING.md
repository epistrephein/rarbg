# Contributing

First off, thank you for considering contributing to this project.

As part of the open source community, this project thrives thanks to the help
and the contributions of its users. There are many ways to contribute - from
submitting bug reports and feature requests, to improving the documentation, or
writing code which can be incorporated into the codebase.

In these guidelines, you will find descriptions of some of the most common
scenarios related to contributing and a bit of information on how to proceed to
make sure that your submission can be evaluated swiftly and properly.

This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the
[Code of Conduct](https://github.com/epistrephein/rarbg/blob/master/CODE_OF_CONDUCT.md).

## Opening an issue

Opening an issue on GitHub is the fastest way to get in touch with the maintainers
of the project and start a discussion regarding a problem you're experiencing or
a missing feature you would like to suggest.

For this reason, upon opening a new issue, you'll be able to choose between
different templates for your submission, with some pre-allocated sections to fill.
Please try to follow the existing structure of the issue and to provide as much
information as possible regarding your situation. This will help the maintainers
to reproduce the bug or effectively consider the feature you'd like to see
implemented.

If you think your issue doesn't fit into any of the existing templates, or if you
just have a question regarding the existing functionalities of the project,
simply open a regular issue and describe the problem in the clearest way possible.

## Contributing with code

If you would like to contribute to the project by writing code, you can open a
Pull Request on GitHub with your changes and ask a maintainer for a review.

As an open source Ruby gem, this projects uses the most common development tools
to test, validate, and document the code.

### Tools and integrations

We use [RSpec](http://rspec.info/) as testing framework.  
The test suite lives in the `spec` directory, and you can run it to test your
changes with `rake spec`.

We also use [RuboCop](https://docs.rubocop.org/en/latest/) to enforce code style.  
The configuration file used for this project lives in `.rubocop.yml`. You can check
the code style of your changes with `rake rubocop`.

The default Rake task, runnable using `rake`, performs code linting via Rubocop
and then runs the RSpec tests.

Documentation is written as [YARD](https://yardoc.org/) docblocks in the Ruby code.  
This is rendered as self-hosted Web pages on [GitHub pages](https://epistrephein.github.io/rarbg/).
Sources are stored in the repository under the `docs` folder and can be automatically
generated and updated via `rake yard`.  
The completeness of the documentation is then measured via
[Inch CI](https://inch-ci.org/github/epistrephein/rarbg).

Continuous integration and automated tests are run on
[Travis CI](https://travis-ci.org/epistrephein/rarbg) and integrated with the
GitHub Pull Request flow.

Code quality and test coverage are then scored via
[CodeClimate](https://codeclimate.com/github/epistrephein/rarbg).

Finally, dependencies are kept up-to-date thanks to
[Depfu](https://depfu.com/github/epistrephein/rarbg) integration.

### Submitting a PR

This project follows the [GitHub flow](https://guides.github.com/introduction/flow/)
for Pull Request submissions.

To submit a PR with your proposed changes, follow these steps:

1. [Fork the repo](https://github.com/epistrephein/rarbg/fork) in your GitHub
userspace and clone it locally
2. Install the dependencies with bundler (`bin/setup`)
3. Create a feature branch (`git checkout -b my-new-feature`)
4. Add your code to the branch and then commit the changes (`git commit -am 'Add some feature'`)
5. Run the test suite (`rake spec`) and make sure that existing and newly introduced
tests pass. You can also run Rubocop linting with `rake rubocop`, or just use `rake`
to run both Rubocop and RSpec tests
6. Push to your remote branch on GitHub (`git push origin my-new-feature`)
7. Create a [new pull request](https://github.com/epistrephein/rarbg/pulls)

As for issues, when opening a new Pull Request, please fill out the template with
all the relevant information in order to reduce the review effort of the maintainers.
