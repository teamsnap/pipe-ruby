module Pipe
  class Config
    attr_accessor :raise_on_error
    attr_reader :error_handlers, :skip_on, :stop_on

    def initialize(
      error_handlers: [],
      raise_on_error: true,
      skip_on: false,
      stop_on: false
    )
      @error_handlers = error_handlers
      @raise_on_error = raise_on_error
      self.skip_on = skip_on
      self.stop_on = stop_on
    end

    def error_handler(&block)
      error_handlers << block if block_given?
    end

    def break?(subj)
      stop_on.call(subj)
    rescue ArgumentError
      stop_on.call
    end

    def raise_on_error?
      raise_on_error ? true : false
    end

    def skip?(subj)
      skip_on.call(subj)
    rescue ArgumentError
      skip_on.call
    end

    def skip_on=(val)
      @skip_on = (val.respond_to?(:call) ? val : lambda { |obj| val })
    end

    def stop_on=(val)
      @stop_on = (val.respond_to?(:call) ? val : lambda { |obj| val })
    end
  end
end

