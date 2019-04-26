# Distance::Calculator

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/distance/calculator-calculator`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'distance-calculator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install distance-calculator

## Usage

#### Math formula

    $ coords = [['2.78788', '3.578787'], ['3.6565', '55.6434']], [['2.98788', '9.578787'], ['6.6565', '75.6434']], [['6.78788', '7.578787'], ['12.6565', '15.6434']]
    DistanceCalculator::MathFormula.new(coords).calculate_distance_with_math

#### API with Google matrix distance

    $  DistanceCalculator::Api.new.calculate_distance_with_api(
       origins: ["48.92088132,2.210950607"],
       destinations: ["48.922024,2.206292"])

## Todo

-   Testing with minitest

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/distance-calculator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Distance::Calculator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/distance-calculator/blob/master/CODE_OF_CONDUCT.md).
