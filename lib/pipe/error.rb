module Pipe
  HandlerError = Module.new
  IterationError = Module.new
  ReducerError = Module.new

  class Error
    def self.process(data: {}, error:, namespace:)
      new(error).rewrite_as(:namespace => namespace, :data => data)
    end

    def initialize(e)
      @e = e
    end

    def rewrite_as(data: {}, namespace:)
      subclass = find_or_create_subclass(namespace)
      raise subclass, "#{e} [#{data}, #{e.class}]", e.backtrace
    end

    private

    attr_reader :e

    def find_or_create_subclass(namespace)
      part = e.class.name.split("::").last
      subclass_name = "#{namespace.name}::#{part}"

      begin
        subclass_name.constantize
      rescue NameError
        eval "#{subclass_name} = Class.new(StandardError)"
      end

      subclass_name.constantize
    end
  end
end

