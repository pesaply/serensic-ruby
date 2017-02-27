Serensic Client Library for Ruby
=============================
This is the Ruby client library for serensic's API. To use it you'll
 [Installation](#installation)
 [Usage](#usage)
 [SMS API](#sms-api)
 [Coverage](#api-coverage)
 [License](#license)
Installation
------------
To install the Ruby client library using Rubygems:
   gem install serensic
Alternatively you can clone the repository:
git clone git@github.com:pesaply/serensic-ruby.git
Usage
Begin by requiring the serensic library:
ruby
require 'serensic'
Then construct a client object with your user and secret:
```ruby
client = serensic::Client.new(user: 'YOUR-API-USER', secret: 'YOUR-API-SECRET')
```
For production you can specify the `SERERNSIC_USER` and `SERENSIC_SECRET`
environment variables instead of specifying the key and secret explicitly.
## SMS API
### Send a text message

```ruby
response = client.send_message(to: 'YOUR NUMBER', msg: 'Hello world')
unless response['data'].nil? || response['data'][0]['status'] != 'OK'
  puts "Sent message #{response['data'][0]['smslog_id']}"
else
  puts "Error: #{response['error_string']}"
end
```
API Coverage
------------
 Messaging
 Send
 Delivery Receipt
 Inbound Messages
 Search
 reports
 Message
 Messages
 Rejections


License
-------
This library is released under the [MIT License][license]

[license]: LICENSE.txt
