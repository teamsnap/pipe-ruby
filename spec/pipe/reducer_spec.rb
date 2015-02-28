require "spec_helper"

describe Pipe::Reducer do
  describe "#reduce" do
    it "calls each method in #through, passing #subject as the first arg" do
      context = Class.new do
        def stringify(subj)
          subj.to_s
        end

        def symbolize(subj)
          subj.to_sym
        end
      end.new
      subject = Object.new
      str_subject = subject.to_s
      through = [:stringify, :symbolize]
      reducer = Pipe::Reducer.new(
        :config => Pipe::Config.new,
        :context => context,
        :subject => subject,
        :through => through
      )

      expect(subject).to receive(:to_s).and_return(str_subject)
      expect(str_subject).to receive(:to_sym)

      reducer.reduce
    end

    it "returns the resulting value" do
      context = Class.new do
        def stringify(subj)
          subj.to_s
        end

        def symbolize(subj)
          subj.to_sym
        end
      end.new
      subject = Object.new
      through = [:stringify, :symbolize]
      reducer = Pipe::Reducer.new(
        :config => Pipe::Config.new,
        :context => context,
        :subject => subject,
        :through => through
      )

      expect(reducer.reduce).to eq(subject.to_s.to_sym)
    end

    it "breaks when told to and returns the current altered value of subject" do
      config = Pipe::Config.new(
        :stop_on => proc { |_, method|
          method == :downcase
        }
      )
      context = Class.new do
        def downcase(subj)
          subj.downcase
        end

        def stringify(subj)
          subj.to_s
        end

        def symbolize(subj)
          subj.to_sym
        end
      end.new
      subject = Object.new
      through = [:stringify, :downcase, :symbolize]
      reducer = Pipe::Reducer.new(
        :config => config,
        :context => context,
        :subject => subject,
        :through => through
      )

      expect(reducer.reduce).to eq(subject.to_s)
    end

    it "skips when told to" do
      config = Pipe::Config.new(
        :skip_on => proc { |_, method|
          method == :downcase
        }
      )
      context = Class.new do
        def downcase(subj)
          subj.downcase
        end

        def stringify(subj)
          subj.to_s
        end

        def symbolize(subj)
          subj.to_sym
        end
      end.new
      subject = Object.new
      through = [:stringify, :downcase, :symbolize]
      reducer = Pipe::Reducer.new(
        :config => config,
        :context => context,
        :subject => subject,
        :through => through
      )

      expect(reducer.reduce).to eq(subject.to_s.to_sym)
    end

    it "calls the error handlers when a raise occurs" do
      handler1 = Proc.new {}
      handler2 = Proc.new {}
      config = Pipe::Config.new(:error_handlers => [handler1, handler2])
      context = Class.new do
        ExpectedError = Class.new(StandardError)

        def bomb
          raise ExpectedError, "BOOM!"
        end
      end

      expect(handler1).to receive(:call)
      expect(handler2).to receive(:call)

      expect{
        Pipe::Reducer.new(
          :config => config,
          :context => context,
          :subject => Object.new,
          :through => [:bomb]
        ).reduce
      }.to raise_error
    end

    it "honors Config#raise_on_error" do
      config = Pipe::Config.new(:raise_on_error => false)
      context = Class.new do
        AnotherExpectedError = Class.new(StandardError)

        def bomb
          raise AnotherExpectedError, "BOOM!"
        end
      end

      expect{
        Pipe::Reducer.new(
          :config => config,
          :context => context,
          :subject => Object.new,
          :through => [:bomb]
        ).reduce
      }.to_not raise_error
    end
  end
end
