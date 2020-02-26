require "spec_helper"

describe Pipe::Iterator do
  describe "#iterate" do
    it "passes config, context and through to Reducer for each subject" do
      subjects = [1, 2]
      config = Pipe::Config.new
      context = Object.new
      through = [:to_s, :to_sym]
      iterator = Pipe::Iterator.new(
        :config => config,
        :context => context,
        :subjects => subjects,
        :through => through
      )

      subjects.each do |subject|
        expect(Pipe::Reducer).to receive(:new).with(
          :config => config,
          :context => context,
          :subject => subject,
          :through => through
        ).and_return(double(:reduce => true))
      end

      iterator.iterate
    end

    describe "when an error occurs" do
      it "raises an error" do
        dub = Object.new
        dub.singleton_class.send(:define_method, :reduce) do
          raise StandardError, "fail"
        end
        iterator = Pipe::Iterator.new(
          :config => Pipe::Config.new(),
          :context => Object.new,
          :subjects => [Object.new],
          :through => [:to_s]
        )
        expect(Pipe::Reducer).to receive(:new).and_return(dub)

        expect{ iterator.iterate }.to raise_error
      end
    end
  end
end
