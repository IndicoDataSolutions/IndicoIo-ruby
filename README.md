# IndicoIo-ruby

A Ruby wrapper for indico's APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'indico'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install indico

Documentation
------------
Found [here](http://indico.readme.io/v1.0/docs)

## Usage

```ruby
> require 'indico'

=> true

> Indico.political("Guns don't kill people. People kill people.")

=> {"Libertarian"=>0.47740164630834825, "Liberal"=>0.16617097211030055, "Green"=>0.08454409540443657, "Conservative"=>0.2718832861769146}

> Indico.sentiment("This song is incredible")

=> {"Sentiment"=>0.900475156188022}

> Indico.language('Quis custodiet ipsos custodes')

=> {"Swedish"=>0.00033330636691921914, "Vietnamese"=>0.0002686116137658802, "Romanian"=>8.133913804076592e-06, "Dutch"=>0.09380619821813883, "Korean"=>0.00272046505489883, "Danish"=>0.0012556466207667206, "Indonesian"=>6.623391878530033e-07, "Latin"=>0.8230599921384231, "Hungarian"=>0.0012793617391960567, "Persian (Farsi)"=>0.0019848504383980473, "Lithuanian"=>0.007328693814717631, "French"=>0.00016792646226101638, "Norwegian"=>0.0009179030069742254, "Russian"=>0.0002643396088456642, "Thai"=>7.746466749651003e-05, "Finnish"=>0.0026367338676522643, "Hebrew"=>3.70933525938127e-05, "Bulgarian"=>3.746416283126873e-05, "Turkish"=>0.0004606965429738638, "Greek"=>0.027456554742563633, "Tagalog"=>0.0005143018200605518, "English"=>0.00013517846159760138, "Arabic"=>0.00013589586110619373, "Italian"=>2.650711180999111e-06, "Portuguese"=>0.013193681336032896, "Chinese"=>0.008818957727120736, "German"=>0.00011732494215411359, "Japanese"=>0.0005885208894664065, "Czech"=>9.916434007248934e-05, "Slovak"=>8.869445598583308e-05, "Spanish"=>0.011844579596827902, "Polish"=>9.900290296255447e-05, "Esperanto"=>0.0002599482830232367}

> Indico.text_tags('This coconut green tea is amazing!');

=> { "food"=>0.3713687833244494, "cars"=>0.0037924017632370586, ...}

```

###Batch API Access

If you'd like to use our batch api interface, please check out the [pricing page](https://indico.io/pricing) on our website to find the right plan for you.

```ruby
> require 'indico'

=> true

> data = ["I believe in capital punishment", "The president is wrong"]

=> ["I believe in capital punishment", "The president is wrong"]

> Indico.batch_political(data)

=> [ {"Libertarian"=>0.3511057701654774, "Liberal"=>0.06709112089656208, "Green"=>0.03830472376983833, "Conservative"=>0.5434983851681222}, {"Libertarian"=>0.08762905907467175, "Liberal"=>0.18965142341591298, "Green"=>0.02612359787701222, "Conservative"=>0.696595919632403}]
````

###Private cloud API Access

If you're looking to use indico's API for high throughput applications, please check out the [pricing page](https://indico.io/pricing) on our website to find the right plan for you.

```ruby
> require 'indico'

=> true

> data = ["I believe in capital punishment", "The president is wrong"]

=> ["I believe in capital punishment", "The president is wrong"]

> Indico.batch_political(data, "my-private-cloud")

=> [ {"Libertarian"=>0.3511057701654774, "Liberal"=>0.06709112089656208, "Green"=>0.03830472376983833, "Conservative"=>0.5434983851681222}, {"Libertarian"=>0.08762905907467175, "Liberal"=>0.18965142341591298, "Green"=>0.02612359787701222, "Conservative"=>0.696595919632403}]
````

The `cloud` parameter redirects API calls to your private cloud hosted at `[cloud].indico.domains`


###Configuration

Indicoio-java will search ./.indicorc and $HOME/.indicorc for the optional configuration file. Values in the local configuration file (./.indicorc) take precedence over those found in a global configuration file ($HOME/.indicorc). The indicorc file can be used to set an authentication username and password or a private cloud subdomain, so these arguments don't need to be specified for every api call. All sections are optional.

Here is an example of a valid indicorc file:


```
[auth]
api_key=example-api-key

[private_cloud]
cloud = example-private-cloud
```

Environment variables take precedence over any configuration found in the indicorc file.
The following environment variables are valid:

```
$INDICO_API_KEY
$INDICO_CLOUD
```

Variables set with a `Indico.private_cloud = cloud` or `Indico.api_key = api_key` override any environment variables or configuration found in the indicorc file for any subsequent api calls, like so:

```ruby
Indico.api_key = 'example-api-key'
Indico.private_cloud = 'example-private_cloud'

Indico.sentiment('This song is incredible')
```


Finally, any values explicitly passed in to an api call will override configuration options set in the indicorc file, in an environment variable, or with a `Indico.private_cloud = cloud` or `Indico.api_key = api_key` call. These values are sent in a config map, as shown:

```ruby
api_key = 'example-api-key'
private_cloud = 'test-cloud'
config = { api_key: api_key, cloud: private_cloud }

Indico.sentiment('This song is incredible', config)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/indico/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
