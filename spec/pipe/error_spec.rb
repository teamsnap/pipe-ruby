require "spec_helper"

Namespace = Module.new

describe Pipe::Error do
  describe ".process" do
    it "re-renders the error under the namespace passed" do
      begin
        begin
          not_a_method(:boom)
        rescue => e
          Pipe::Error.process(:error => e, :namespace => Namespace)
        end
      rescue => e
        @err = e
      end

      expect(@err.class.name).to eq("Namespace::NoMethodError")
    end

    it "adds the original error class to the message" do
      begin
        begin
          not_a_method(:boom)
        rescue => e
          Pipe::Error.process(:error => e, :namespace => Namespace)
        end
      rescue => e
        @err = e
      end

      expect(@err.message).to match(Regexp.new("NoMethodError"))
    end

    it "adds the data passed to the message" do
      data = {:one => 1, :two => 2}
      begin
        begin
          not_a_method(:boom)
        rescue => e
          Pipe::Error.process(
            :data => data,
            :error => e,
            :namespace => Namespace
          )
        end
      rescue => e
        @err = e
      end

      expect(@err.message).to match(Regexp.new("#{data}"))
    end
  end
end
