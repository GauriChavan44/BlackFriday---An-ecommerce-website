#features/support/env.rb

require 'selenium/webdriver'
require 'capybara/cucumber'
url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"

Capybara.register_driver :browserstack do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.new

  if ENV['OS']
    capabilities['os'] = ENV['OS']
    capabilities['os_version'] = ENV['OS_VERSION']
  else
    capabilities['platform'] = ENV['PLATFORM'] || 'ANY'
  end

  capabilities['browser'] = ENV['BROWSER'] || 'chrome'
  capabilities['browser_version'] = ENV['VERSION'] if ENV['VERSION']
  capabilities['browserstack.debug'] = 'true'
  capabilities['project'] = ENV['PROJECT'] if ENV['PROJECT']
  capabilities['build'] = ENV['BUILD'] if ENV['BUILD']

  Capybara::Selenium::Driver.new(app,
    :browser => :remote, :url => url,
    :desired_capabilities => capabilities)
end
