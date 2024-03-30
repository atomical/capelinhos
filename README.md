# Capelinhos

This gem gracefully stops Passenger Ruby processes that have exceeded a memory threshold. It is meant to be added to cron and run at an interval of your choosing.

If Phusion Passenger is configured with `PassengerMinInstances` and the number of processes is under that number, then a new process should replace the processes that were shutdown.

Note: This doesn't skip active long running sessions. This feature be added as a default in the future.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add capelinhos

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install capelinhos

## Usage

# kill up to 3 processes that use more than 400 megabytes
$ capelinos --max-memory 400 --max-processes 3

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capelinhos.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
