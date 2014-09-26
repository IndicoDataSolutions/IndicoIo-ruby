# IndicoIo-ruby

A simple Ruby Wrapper for the indico set of APIs

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

> Indico.political("Guns don't kill people. People kill people.")

> Indico.posneg("Guns don't kill people. People kill people.")

> Indico.language('Quis custodiet ipsos custodes')
```

###Local

When using a local version of the api you must remember to require 'indico_local' instead of 'indico'. Along the same vein, the package is then referenced as "IndicoLocal" rather than "Indico".

```ruby
> require 'indico_local'

> IndicoLocal.sentiment("I love using this tool!")

=> {"Sentiment"=>0.7483253499779664}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/indico/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
