# PayPro Ruby Library

[![build](https://github.com/paypronl/paypro-ruby/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/paypronl/paypro-ruby/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

The PayPro Ruby library can be used to make integrating with the PayPro API easier when using Ruby.
It provides easy to use classes to interact with all resources available through the API.

It also provides the following:

- Built-in pagination support
- Easy configuration
- Webhook request verification helpers

## Requirements

- Ruby >= 3.0.0

## Installation

You can install the gem like this:

```sh
gem install paypro
```

If you'd rather install the gem through `bundler` you can put this in your Gemfile:

```ruby
source 'https://rubygems.org'

gem 'paypro'

```

## Getting started

In order to use the API you need to have a valid API key.
You can find your API key in the [PayPro dashboard](https://app.paypro.nl/developers/api-keys)

Example of using the API:

```ruby
require 'paypro'

client = PayPro::Client.new('pp_...')

# Creating a payment
payment = client.payments.create({ amount: 500, currency: 'EUR', description: 'Test Payment' })

# Retrieving all subscriptions
subscriptions = client.subscriptions.list

# Retrieving a single customer
customer = client.customers.get('CUSSDGDCJVZH5K')

```

## Per-request configuration

When you have multiple API keys to use during a single request, you can specify these in all requests.

```ruby
require 'paypro'

client = PayPro::Client.new('pp_...')

# Creating a payment
payment = client.payments.create({ amount: 500, currency: 'EUR', description: 'Test Payment' }, api_key: 'pp_...')

# Retrieving five subscriptions
subscriptions = client.subscriptions.list({ limit: 5 }, api_key: 'pp_...')

# Retrieving a single customer
customer = client.customers.get('CUSSDGDCJVZH5K', api_key: 'pp_...', api_url: 'https://api-test.paypro.nl')
```

## Development

If you want to contribute to this project you can fork the repository. Create a new branch, add your feature and create a pull request. We will look at your request and determine if we want to add it.

To run all the tests:

```sh
bundle exec rspec
```

To run the linter:

```sh
bundle exec rubocop
```

To run an `irb` with the gem already required you can use:

```sh
bin/console
```
