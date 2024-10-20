# ⚙️ConfigX

ConfigX is a simple configuration library that you can use with your application or libraries.

ConfigX is NOT that kind of library that allows you configuring any Ruby object, instead
it takes a different approach. It reads configuration from YAML files and environment variables
and load it into a ruby object. It's highly influenced by the [config] gem, but it does
not define a global objects and allows you having multiple independent configurations.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add configx

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install configx

## Usage

Start using the library as simple as loading configuration from default locations:

```ruby
config = ConfigX.load
```

It loads configuration from the following locations in the specified order:

1. `config/settings.yml`
2. `config/settings/production.yml`
3. `config/settings.local.yml`
4. `config/settings/production.local.yml`
5. Environment variables

All the configuration source are merged an intuitive way. For instance, 

* **config/settings.yml**

```yaml
---
api: 
  enabled: false 
  endpoint: https://example.com 
  access_token: 
```

* **config/settings/production.yml**

```yaml
---
api: 
  enabled: true
```

* Environment Variables

``` 
export SETTINGS__API__ACCESS_TOKEN=foobar
```

The resulting configuration will be:

```ruby
config = ConfigX.load
config.api.enabled # => true
config.api.endpoint # => "https://example.com"
config.api.access_token # => "foobar"
```

### Customizing Configuration

You can customize the configuration by passing optional arguments to the `load` method:

```ruby
ConfigX.load(
  "development",
  dir_name: 'settings',
  file_name: 'settings',
  config_root: 'config',
  env_prefix: 'SETTINGS',
  env_separator: '__'
)
```

The first four options, `env` (positional), `dir_name`, `file_name`, and `config_root` are used to specify 
the configuration files to read:

1. `{config_root}/{file_name}.yml`
2. `{config_root}/{file_name}/{env}.yml`
3. `{config_root}/{file_name}.local.yml`
4. `{config_root}/{file_name}/{env}.local.yml`


The `env_prefix` and `env_separator` options are used to specify how the environment variables should be constructed. In
the above example, they start from `SETTINGS` and use `__` as a separator. 

For instance, the following environment variable: 

```
export SETTINGS__API__ACCESS_TOKEN=foobar
```

corresponds to the following configuration:

```yaml
---
api:
  access_token: foobar
```

You can also pass boolean value to environment variables using convenient YAML syntax:

```sh
export SETTINGS__API__ENABLED=true
export SETTINGS__API__ENABLED=false
export SETTINGS__API__ENABLED=on
export SETTINGS__API__ENABLED=off
```

Environment variables have the highest priority and override the values from the configuration files. 

Sometimes you may want to just load configuration from a single source, for example, from for testing purposes:

```ruby
config = ConfigX.from({api: {enabled: true}})
config.api.enabled # => true
```

### Typed Config 

ConfigX allows you to define typed configuration using the `ConfigX::Config` class which uses the `dry-struct` library 
under the hood. 

```ruby 
class Config < ConfigX::Config
  attribute :api do 
    attribute :enabled, Types::Bool.default(false)
    attribute :endpoint, Types::String
    attribute :access_token, Types::String
  end
end 
```

You can then load the configuration using the `load` method:

```ruby
config = ConfigX.load(config_class: Config)
config.api.enabled #=> true
config.api.endpoint #=> "https://example.com"
```

Using typed configuration allows you to define the structure of the configuration and automatically cast values to the
specified types.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bolshakov/configx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[config]: https://rubygems.org/gems/config
