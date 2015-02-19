require "pipe/ext/inflection"

module Pipe
  module Ext
    module String
      unless "".respond_to? :constantize
        def constantize
          Inflection.constantize(self)
        end
      end
    end
  end
end

class String
  include Pipe::Ext::String
end
