# IndicoIo-ruby

A ruby wrapper for the [indico API](http://indico.io).

Installation
-------------

Add this line to your application's Gemfile:

    gem 'indico'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install indico


API Keys + Setup
----------------
For API key registration and setup, checkout our [quickstart guide](http://docs.indico.io/v2.0/docs/api-keys).

Full Documentation
------------
Detailed documentation and further code examples are available at [indico.reame.io](http://indico.readme.io/v2.0/docs/ruby)

Examples
---------

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

Batch API
---------

Each `Indico` method has a corresponding batch method for analyzing many examples with a single request. Simply pass in an array of inputs and receive an array of results in return.


```ruby
> require 'indico'

=> true

> Indico.api_key = "YOUR_API_KEY"

=> "YOUR_API_KEY"

> Indico.batch_sentiment(['Best day ever', 'Worst day ever'])

=> [0.9899001220871786, 0.005709885173415242]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/indico/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
