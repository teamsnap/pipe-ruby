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
        Reducer.new(
          config: config,
          context: context,
          subject: subject,
          through: through
        ).reduce
      }
    end

    private
    attr_accessor :config, :context, :subjects, :through

  end
end

