# Monyewire

This is an API wrapper for Moneywire (Supercapital) API: http://api-docs.supercapital.uk/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moneywire', git: 'git@github.com:currencytransfer/moneywire.git',
                 <branch|tag>: <name>
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moneywire

## Usage

```
Moneywire.environment = <:demo|:production>
client = Moneywire::Client.new(<login_id>, <api_key>, <token_if_you_have_one>)
result = client.quotes.create(
  sellCurrency: 'EUR',
  buyCurrency: 'GBP',
  fixedSide: :sell,
  amount: 15_000,
  deliveryDate: '2016-02-16'
)
```

If you need to log the raw requests/response that were sent to the API, you can use:
```
client.on_response_received do |response, is_successful|
  # response: is an HTTParty Response object
  # http://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response
  body = response.body
  headers = response.headers

  # response.request is an HTTParty Request object
  # http://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Request
  request = response.request
  uri = request.uri
  http_method = request.http_method
  request_options = request.options
end
```

Once authenticated the gem stores the authentication token and uses it for as long as it is still valid, and will auto renew it in case the API responds with 401 Authentication Failed.
In case you need to know when this happens (to cache the token for future use)
```
client.on_token_renewed do |new_token|
  # cache the new token somewhere
end
```

Most of the endpoints of the API are implemented as methods in one of:
`client.quotes`, `client.conversions`, `client.reference`. If something is missing you still can fall back to using:
```
client.get(uri, params = {}, options = {})
client.post(uri, params = {}, options = {})

client.get('/reference/conversion-dates/schedules')
```
Still it is preferable that a wrapper method is implemented and added to the gem. And covered with integration tests.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

We are using VCR for recording API request/response.
If you need to implement changes in the API interface, you'll need to add/edit `spec/env.yml`
with correct demo credentials and before you run the tests delete the corresponding
recorder request/response from `spec/fixtures/vcr_cassettes`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/moneywire.

