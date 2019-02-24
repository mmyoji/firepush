# Firepush

[![Build Status](https://travis-ci.org/mmyoji/firepush.svg?branch=master)](https://travis-ci.org/mmyoji/firepush)

Firepush is [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/) client library using [HTTP v1 API](https://firebase.google.com/docs/cloud-messaging/migrate-v1).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'firepush'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install firepush

## Usage

You can see the following link to understand the FCM messages.

[About FCM messages | Firebase](https://firebase.google.com/docs/cloud-messaging/concept-options?hl=en)

```rb
require "firepush"

client = Firepush::Client.new(
  access_token: "<your Firebase Project Access Token>",
  project_id:   "<your Firebase project ID>",
)

# 1. Notification message to a single device
client.push(
  notification: {
    title: "Hello",
    body:  "from firepush!",
  },
  token: "<client token>",
)

# 2. Data message to a topic
client.push(
  data: {
    key:  "foo",
    key2: "bar",
  },
  topic: "news",
)

# 3. You can set both Notification/Data message types
client.push(
  notification: {
    title: "Hello",
    body:  "from firepush!",
  },
  data: {
    key:  "foo",
    key2: "bar",
  },
  topic: "news",
)

# or you can set message beforehand.
client.message = {
  notification: {
    title: "hey"
    body:  "siri",
  },
  topic: "apple",
}
client.push
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmyoji/firepush. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Firepush project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mmyoji/firepush/blob/master/CODE_OF_CONDUCT.md).
