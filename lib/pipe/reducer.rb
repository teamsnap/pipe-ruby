module Pipe
  class Reducer
    def initialize(config:, context:, subject:, through:)
      self.config = config
      self.context = context
      self.subject = subject
      self.through = through
    end

    def reduce
      through.reduce(subject) { |subj, method|
        break subj if config.break?(subj, method, through)
        process(subj, method)
      }
    end

    private

    attr_accessor :config, :context, :subject, :through

    def process(subj, method)
      if config.skip?(subj, method, through)
        subj
      else
        context.send(method, subj)
      end
    end
  end
end

