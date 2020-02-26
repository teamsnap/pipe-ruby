module Pipe
  class Config
    attr_reader :skip_on, :stop_on

    def initialize(
      skip_on: false,
      stop_on: false
    )
      self.skip_on = skip_on
      self.stop_on = stop_on
    end

    def break?(*args)
      stop_on.call(*args) ? true : false
    end

    def skip?(*args)
      skip_on.call(*args) ? true : false
    end

    def skip_on=(val)
      @skip_on = as_proc(val)
    end

    def stop_on=(val)
      @stop_on = as_proc(val)
    end

    private

    def as_proc(val)
      val.respond_to?(:call) ? val : proc { val }
    end
  end
end

