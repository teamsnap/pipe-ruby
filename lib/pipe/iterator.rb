module Pipe
  class Iterator
    def initialize(config:, context:, subjects:, through:)
      self.config = config
      self.context = context
      self.subjects = subjects
      self.through = through
    end

    def iterate
      subjects.map { |subject|
        begin
          Reducer.new(
            config: config,
            context: context,
            subject: subject,
            through: through
          ).reduce
        rescue => e
          handle_error(:error => e, :subject => subject)
          subject
        end
      }
    end

    private

    attr_accessor :config, :context, :subjects, :through

    def handle_error(error:, subject:)
      if config.raise_on_error?
        Error.process(
          :data => { :subject => subject },
          :error => error,
          :namespace => IterationError,
        )
      end
    end
  end
end

