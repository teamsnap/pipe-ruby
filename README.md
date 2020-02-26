# Pipe

`pipe-ruby` is an implementation of the UNIX pipe command. It exposes two
instance methods, `pipe` and `pipe_each`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "pipe-ruby", :require => "pipe"
```

After bundling, include the `Pipe` module in your class(es)

```ruby
class MyClass
  include Pipe

  # ...
end
```

## Default Usage

### #pipe

```ruby
pipe(subject, :through => [
  :method1, :method2#, ...
])
```

Just as with the UNIX pipe, `subject` will be passed as the first argument to
`method1`. The results of `method1` will be passed to `method2` and on and
on. The result of the last method called will be returned from the pipe.

### #pipe_each

```ruby
pipe_each([subj1, subj2], :through => [
  :method1, :method2#, ...
])
```

`pipe_each` calls `pipe`, passing each individual subject. It will return a
mapped array of the responses.

## Configurable Options

After implementing the `pipe` method in a few different places, we found that a
slightly different version was needed for each use case. `Pipe::Config` allows
for this customization per call or per class implementation. There are four
configurable options. Here they are with their defaults:

```ruby
Pipe::Config.new(
  :skip_on => false,            # a truthy value or proc which tells pipe to skip
                                # the next method in the `through` array

  :stop_on => false             # a truthy value or proc which tells pipe to stop
                                # processing and return the current value
)
```

A `Pipe::Config` object can be passed to the pipe method one of three ways.

NOTE: The options below are in priority order, meaning an override of the
`pipe_config` method will take precedence over an override of the `@pipe_config`
instance variable.

You can pass it to pipe when called:

```ruby
class MyClass
  include Pipe

  def my_method
    config = Pipe::Config.new(:skip_on => false)
    subject = Object.new

    pipe(subject, :config => config, :through => [
      # ...
    ])
  end

  # ...
end
```

Or override the `pipe_config` method:

```ruby
class MyClass
  include Pipe

  def pipe_config
    Pipe::Config.new(:skip_on => false)
  end

  # ...
end
```

Or you can assign it to the `@pipe_config` instance variable:

```ruby
class MyClass
  include Pipe

  def initialize
    @pipe_config = Pipe::Config.new(:skip_on => false)
  end

  # ...
end
```

## Skipping / Stopping Execution

At the beginning of each iteration, `Pipe::Config#stop_on` is called. If it
returns truthy, execution will be stopped and the current value of subject will
be returned. A falsey response will allow the execution to move forward.

If not stopped, `Pipe::Config#skip_on` will be called. Truthy responses will
cause the current value of subject to be passed to the next iteration without
calling the method specified in the current iteration. Falsey responses will
allow the specified method to be called.

Both skip_on and stop_on will receive three arguments when they're called, the
current value of subject, the method to be called on this iteration and the
value of `#through`.

## Contributing

First: please check out our [style guides](https://github.com/teamsnap/guides/tree/master/ruby)...
we will hold you to them :)

1. Fork it ( https://github.com/[my-github-username]/pipe-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make sure you're green (`bundle exec rspec`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## Testing

`bundle exec rspec`

We like to have good coverage of each major feature. Before contributing with a
PR, please make sure you've added tests and are fully green.

