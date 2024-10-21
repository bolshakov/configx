# ⚙️ConfigX

ConfigX is a lightweight configuration library that helps you manage settings for applications or libraries. 
Unlike other configuration libraries, ConfigX does not allow configuring arbitrary Ruby objects. Instead, 
it focuses on loading configuration from YAML files and environment variables into structured Ruby objects. 
Inspired by the [config] gem, ConfigX avoids defining global objects and supports multiple 
independent configurations.

## Installation

To install, add the gem to your Gemfile:

```bash
$ bundle add configx
```

Or, if you’re not using Bundler:

```bash
$ gem install configx
```

## Usage

To load configuration from the default locations, use:

```ruby
config = ConfigX.load
```

This loads configuration from the following sources in order:

1. `config/settings.yml`
2. `config/settings/production.yml`
3. `config/settings.local.yml`
4. `config/settings/production.local.yml`
5. Environment variables

The configuration is merged in an intuitive way, with environment variables taking precedence. For example: 

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

Results in:

```ruby
config = ConfigX.load
config.api.enabled # => true
config.api.endpoint # => "https://example.com"
config.api.access_token # => "foobar"
```

### Customizing Configuration

You can customize how configurations are loaded:

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

Explanation of options:

* `env`, `dir_name`, `file_name`, and `config_root` specify where to look for configuration files.

In this example ConfigX will look for configuration files in the following order:

1. `{config_root}/{file_name}.yml`
2. `{config_root}/{file_name}/{env}.yml`
3. `{config_root}/{file_name}.local.yml`
4. `{config_root}/{file_name}/{env}.local.yml`

* `env_prefix` and `env_separator` define how environment variables map to configuration keys.

For example, with the following environment variable:

```
export SETTINGS__API__ACCESS_TOKEN=foobar
```

ConfigX loads it into:

```yaml
---
api:
  access_token: foobar
```

### Environment Variable Parsing

ConfigX automatically parses environment variable values and converts them to the appropriate types where possible. 
It handles strings, booleans, numbers, and even arrays. The following types are supported:

#### Booleans:

```bash
export SETTINGS__API__ENABLED=true
export SETTINGS__API__ENABLED=false
export SETTINGS__API__ENABLED=on
export SETTINGS__API__ENABLED=off
```

These values will be parsed into their corresponding boolean types (`true` or `false`):

```ruby 
config.api.enabled # => true or false
```

#### Numbers:

```bash
export SETTINGS__API__RETRY_COUNT=5
export SETTINGS__API__TIMEOUT=30.5
```

Numeric values will be parsed as either integers or floats:

```ruby 
config.api.retry_count # => 5
config.api.timeout # => 30.5
```


#### Arrays:

Arrays can be specified by using comma-separated values:

```bash 
export SETTINGS__API__SERVERS='["server1","server2","server3"]'
```

This will be parsed as an array:

```ruby
config.api.servers # => ["server1", "server2", "server3"]
```


#### Strings:

Regular string values remain unchanged:

```bash
export SETTINGS__API__ACCESS_TOKEN="my_secret_token"
```

This will simply be loaded as a string:

```ruby
config.api.access_token # => "my_secret_token"
```

Environment variables have the highest precedence and will override values from YAML configuration files. 
This ensures that any environment-specific settings can be applied without modifying the configuration 
files themselves.

### Loading Single Sources

To load configuration from a specific source (e.g., during testing):

```ruby
config = ConfigX.from({api: {enabled: true}})
config.api.enabled # => true
```

### Typed Config 

ConfigX supports typed configurations using `ConfigX::Config`, which leverages [dry-struct]:

```ruby 
class Config < ConfigX::Config
  attribute :api do 
    attribute :enabled, Types::Bool.default(false)
    attribute :endpoint, Types::String
    attribute :access_token, Types::String
  end
end 
```

Load the typed configuration with:

```ruby
config = ConfigX.load(config_class: Config)
config.api.enabled #=> true
config.api.endpoint #=> "https://example.com"
```

Typed configurations enforce structure and type-checking.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bolshakov/configx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[config]: https://rubygems.org/gems/config
[dry-struct]: https://dry-rb.org/gems/dry-struct/
