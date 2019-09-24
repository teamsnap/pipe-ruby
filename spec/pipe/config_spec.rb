require "spec_helper"

describe Pipe::Config do
  describe "defaults" do
    it "sets skip_on to a proc which returns false" do
      expect(Pipe::Config.new.skip_on.call).to eq(false)
    end

    it "sets stop_on to a proc which returns false" do
      expect(Pipe::Config.new.stop_on.call).to eq(false)
    end
  end

  describe "#break?" do
    it "returns a truthy version of the result of calling stop_on" do
      config = Pipe::Config.new(:stop_on => proc { 1 })
      result = config.break?("")
      expect(result).to eq(true)
      config = Pipe::Config.new(:stop_on => proc { nil })
      result = config.break?("")
      expect(result).to eq(false)
    end

    it "passes the first argument to stop_on" do
      config = Pipe::Config.new
      arg = Object.new

      expect(config.stop_on).to receive(:call).with(arg)
      config.break?(arg)
    end
  end

  describe "#skip?" do
    it "returns a truthy version of the result of calling skip_on" do
      config = Pipe::Config.new(:skip_on => proc { 42 })
      result = config.skip?("", "", "", "")
      expect(result).to eq(true)
      config = Pipe::Config.new(:skip_on => proc { false })
      result = config.skip?("", "", "", "")
      expect(result).to eq(false)
    end

    it "passes it's arguments to skip_on" do
      config = Pipe::Config.new

      expect(config.skip_on).to receive(:call).with(1,2,3,4)
      config.skip?(1,2,3,4)
    end
  end

  describe "#skip_on=" do
    describe "when the value passed is a proc" do
      it "assigns the value as is" do
        val = proc { nil }
        config = Pipe::Config.new

        config.skip_on = val
        expect(config.skip_on).to eq(val)
      end
    end

    describe "when the value passed is not a proc" do
      it "wraps the value in a proc prior to assignment" do
        val = "not a proc"
        config = Pipe::Config.new

        config.skip_on = val
        expect(config.skip_on).to be_a(Proc)
        expect(config.skip_on.call).to eq(val)
      end
    end
  end

  describe "#stop_on=" do
    describe "when the value passed is a proc" do
      it "assigns the value as is" do
        val = proc { nil }
        config = Pipe::Config.new

        config.stop_on = val
        expect(config.stop_on).to eq(val)
      end
    end

    describe "when the value passed is not a proc" do
      it "wraps the value in a proc prior to assignment" do
        val = "not a proc"
        config = Pipe::Config.new

        config.stop_on = val
        expect(config.stop_on).to be_a(Proc)
        expect(config.stop_on.call).to eq(val)
      end
    end
  end
end
