# Pipe

`pipe-ruby` is an implementation of the UNIX pipe command. It exposes two
instance methods, `pipe` and `pipe_each`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pipe-ruby'
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
  :error_handlers => [],   # an array of procs to be called when an error occurs
  :raise_on_error => true, # tells Pipe to re-raise errors which occur
  :skip_on => false,       # a truthy value or proc which tells pipe to skip the
                           # next method in the `through` array
  :stop_on => false        # a truthy value or proc which tells pipe to stop
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
    config = Pipe::Config.new(:raise_on_error => false)
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
    Pipe::Config.new(:raise_on_error => false)
  end

  # ...
end
```

Or you can assign it to the `@pipe_config` instance variable:

```ruby
class MyClass
  include Pipe

  def initialize
    @pipe_config = Pipe::Config.new(:raise_on_error => false)
  end

  # ...
end
```

## Error Handling

As we implemented different versions of `pipe` across our infrastructure, we
came across several different error handling needs.

- logging errors that occur in methods called by pipe without raising them
- catching and re-raising errors with additional information so we can still
  see the real backtrace while also gaining insight into which subject and
  method combination triggered the error
- easily seeing which area of the pipe stack we were in when an error occurred

The first layer of error handling is the `error_handlers` attribute in
`Pipe::Config`. Each proc in this array will be called with two arguments,
the actual error object and a context hash containing the method and subject
when the error occurred. If an error occurs within one of these handlers it
will be re-raised inside the `Pipe::HandlerError` namespace, meaning a
`NameError` becomes a `Pipe::HandlerError::NameError`. We also postpend the
current method, current subject and original error class to the message.

NOTE: `Pipe::Config#error_handler` takes a block and adds it to the existing
error handlers.

We have two other namespaces, `Pipe::ReducerError`, which is used when an error
occurs inside during `pipe` execution and `Pipe::IteratorError` for errors which
occur inside of `pipe_each` execution.

Whenever an error occurs in execution (but not in error handler processing), the
response of `Pipe::Config#raise_on_error?` is checked. If this method returns
`true`, the error will be re-raised inside of the appropriate namespace. If it
returns `false`, the current value of `subject` will be returned and execution
stopped.

## Skipping / Stopping Execution

Prior to the execution of each method in the `through` array,
`Pipe::Config#break?` is called with the current value of `subject`. If it
returns truthy, execution will be stopped and the current value of subject
will be returned. A falsey response will allow the execution to move forward.

If the break test allows us to move forward, `Pipe::Config#skip?` will be called
with the current value of `subject`. Truthy responses from this method will
cause the existing value of subject to be carried to the next method without
executing the current specified method. Falsey responses will allow normal
execution of the currently specified method.

## Testing

I'll be adding tests in in the very near future. In the meantime, use at your
own risk :)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pipe-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
