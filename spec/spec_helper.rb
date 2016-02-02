require 'capybara/rspec'
require 'headless'
require 'selenium/webdriver'
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/vendor/'
  add_filter '/spec/'
  add_filter '/config/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['media.navigator.permission.disabled'] = true
  profile['dom.disable_beforeunload'] = true
  Capybara::Selenium::Driver.new(app, profile: profile)
end
Capybara.current_driver = :selenium
