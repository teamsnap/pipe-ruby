require "pry"
require "pipe"
require "simplecov"

SimpleCov.start

module VerifyAndResetHelpers
  def verify(object)
    RSpec::Mocks.proxy_for(object).verify
  end

  def reset(object)
    RSpec::Mocks.proxy_for(object).reset
  end
end

RSpec.configure do |config|
  config.order = "random"

  config.include VerifyAndResetHelpers
end
