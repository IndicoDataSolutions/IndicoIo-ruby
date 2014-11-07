# IndicoIo-ruby

A Ruby wrapper for indico's APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'indico'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install indico

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

###Local

When using a local version of the api you must remember to require 'indico_local' instead of 'indico'. Along the same vein, the package is then referenced as "IndicoLocal" rather than "Indico".

```ruby
> require 'indico_local'

=> true

> IndicoLocal.sentiment("I love using this tool!")

=> {"Sentiment"=>0.7483253499779664}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/indico/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
