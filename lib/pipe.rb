require "pipe/ext/string"
require "pipe/config"
require "pipe/error"
require "pipe/iterator"
require "pipe/reducer"

module Pipe
  def pipe(subject, config: pipe_config, through: [])
    ::Pipe::Reducer.new(
      :config => config,
      :context => self,
      :subject => subject,
      :through => through
    ).reduce
  end

  def pipe_each(subjects, config: pipe_config, through: [])
    ::Pipe::Iterator.new(
      :config => config,
      :context => self,
      :subjects => subjects,
      :through => through
    ).iterate
  end

  private

  def pipe_config
    @pipe_config || Pipe::Config.new
  end
end


