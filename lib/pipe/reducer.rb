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
        begin
          break subj if config.break?(subj, method, through)

          process(subj, method)
        rescue => e
          handle_error(:error => e, :method => method, :subject => subj)
          break error_response(:subject => subj)
        end
      }
    end

    private

    attr_accessor :config, :context, :subject, :through

    def error_response(subject:)
      if config.return_on_error == :subject
        subject
      elsif config.return_on_error.respond_to?(:call)
        config.return_on_error.call(subject)
      else
        config.return_on_error
      end
    end

    def handle_error(error:, method:, subject:)
      process_error_handlers(
        :error => error,
        :method => method,
        :subject => subject
      )

      if config.raise_on_error?
        Error.process(
          :data => { :method => method, :subject => subject },
          :error => error,
          :namespace => ReducerError,
        )
      end
    end

    def process(subj, method)
      if config.skip?(subj, method, through)
        subj
      else
        context.send(method, subj)
      end
    end

    def process_error_handlers(error:, method:, subject:)
      data = { method: method, subject: subject }

      begin
        config.error_handlers.each { |handler| handler.call(error, data) }
      rescue => e
        Error.process(
          :data => data,
          :error => e,
          :namespace => HandlerError,
        )
      end
    end
  end
end

