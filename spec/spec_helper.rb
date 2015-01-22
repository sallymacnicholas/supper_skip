require 'capybara/rspec'
require 'rails_helper'
require 'factory_girl_rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end


  config.include Rails.application.routes.url_helpers

  config.color = true

  config.tty = true
end
