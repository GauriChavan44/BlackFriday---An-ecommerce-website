require 'capybara/rspec'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'site_prism'
require 'httparty'
require 'yaml'
require 'pry'
require 'launchy'
require 'json'
require 'rspec/retry'

# Require all page definitions and helper functions
Dir[File.dirname(__FILE__) + "/pages/*.rb"].each { |file| require file }
Dir[File.dirname(__FILE__) + "/helpers/*.rb"].each { |file| require file }

# BrowserStack driver
url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
Capybara.register_driver :browserstack do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.new

  if ENV['OS']
    capabilities['os'] = ENV['OS']
    capabilities['os_version'] = ENV['OS_VERSION']
  else
    capabilities['platform'] = ENV['PLATFORM'] || 'ANY'
  end
  capabilities['device'] = ENV['DEVICE'] if ENV['DEVICE']
  capabilities['browserName'] = ENV['BROWSERNAME'] if ENV['BROWSERNAME']

  capabilities['browser'] = ENV['BROWSER'] || 'chrome'
  capabilities['browser_version'] = ENV['BROWSER_VERSION'] if ENV['BROWSER_VERSION']

  capabilities['browserstack.debug'] = ENV['DEBUG'] ? ENV['DEBUG'] : 'false'
  capabilities['project'] = ENV['PROJECT'] if ENV['PROJECT']
  capabilities['build'] = ENV['BUILD'] if ENV['BUILD']

  Capybara::Selenium::Driver.new(app,
    :browser => :remote, :url => url,
    :desired_capabilities => capabilities)
end
# Register poltergist driver to drive phantomjs headless browser
Capybara.register_driver :poltergeist do |app|
  options = {
    :timeout => 60,
    :js_errors => false,
    :debug => false,
    :inspector => false,
    :window_size => [1280,800],
    :phantomjs_logger => File.new('phantomjs_console.log', 'w+'),
    :phantomjs_options => ['--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1']}
  Capybara::Poltergeist::Driver.new(app, options)
end

# Register poltergist driver with debug and inspector enabled
Capybara.register_driver :poltergeist_debug do |app|
  options = {
    :timeout => 60,
    :js_errors => false,
    :debug => true,
    :inspector => true,
    :phantomjs_logger => File.new('phantomjs_console.log', 'w+'),
    :phantomjs_options => ['--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1']}
  Capybara::Poltergeist::Driver.new(app, options)
end

# Register the Drag By Funciton
module CapybaraExtension
  def drag_by(right_by, down_by)
    base.drag_by(right_by, down_by)
  end
end
module CapybaraSeleniumExtension
  def drag_by(right_by, down_by)
    driver.browser.action.drag_and_drop_by(native, right_by, down_by).perform
  end
end
::Capybara::Selenium::Node.send :include, CapybaraSeleniumExtension
::Capybara::Node::Element.send :include, CapybaraExtension

# Register selenium driver to drive firefox browser
Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, :browser => :firefox)
end

# Register chrome_driver to drive chrome browser
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

# Register chrome_driver to drive chrome browser
Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, :browser => :safari)
end

# Get test environment: test, dev, staging, selenium
env = ENV['TEST_ENV'] ? ENV['TEST_ENV'] : 'qa-chrome'
host = ENV['HOST_URL'] ? ENV['HOST_URL'] : nil

# Read config values from capybara.yml
config_cap = YAML.load_file("config/capybara.yml")

# Global javascript_flag for use in specs as well
$javascript_flag = config_cap[env]['javascript']

Capybara.default_driver = config_cap[env]["default_driver"]
Capybara.javascript_driver = config_cap[env]['javascript_driver']

Capybara.default_max_wait_time = config_cap[env]["timeout"]
headless = $javascript_flag

# Set app host url if configured
if host != nil
  Capybara.app_host = host
elsif config_cap[env]["app_host"] != nil
  Capybara.app_host = config_cap[env]["app_host"]
else
  puts "Invalid host url"
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # show retry status in spec process
  config.verbose_retry = true
  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true
  # run retry only on features
  config.around :each, :js do |ex|
    ex.run_with_retry retry: 2
  end
  config.before(:each) do |example|
    Capybara.session_name = ":session_#{Time.now.to_i}"
    # Resize window for non-headless browser
    if !headless
      window = Capybara.current_session.driver.browser.manage.window
      window.resize_to(1600, 1400)
      puts "(executing #{File.basename(example.metadata[:file_path])} against #{Capybara.app_host}) with #{Capybara.current_driver}"
    else
      # phantomjs window_size is configured on the driver
      puts "(executing #{File.basename(example.metadata[:file_path])} against #{Capybara.app_host}) with #{Capybara.current_driver}"
    end
  end
  config.after(:each) do |example|
    if Capybara.current_driver == :poltergeist
      networkerror = false
      Capybara.current_session.driver.browser.network_traffic.each do |request|
        request.response_parts.uniq(&:url).each do |response|
          # Status codes: 403 - Forbidden
          if response.status != nil and response.status >= 400 and response.status != 403
            if !networkerror
              puts "Network error:"
              networkerror = true
            end
            puts "#{response.status} - #{response.status_text}: #{response.url}: , #{response.time}"
          end
        end
      end
    end

    # save a screenshot on exception in headless mode
    if example.exception && example.metadata[:js]
      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      time = Time.now.strftime("%Y%m%d%H%M")
      screenshot_name = "screenshot-#{filename}-#{line_number}-#{time}"

      image_screenshot_path = File.join(File.dirname(__FILE__),"screenshots/#{screenshot_name}.png")
      html_screenshot_path = File.join(File.dirname(__FILE__),"screenshots/#{screenshot_name}.html")
      results = File.join(File.dirname(__FILE__),"reports/results.html")

      page.save_screenshot(image_screenshot_path, :full => true)
      Capybara.save_page "#{html_screenshot_path}"

      if image_screenshot_path.include? "/home/jenkins/workspace/"
        image_screenshot_path.gsub! '/home/jenkins/workspace/', 'http://ci.gallerydev.net:8080/job/'
        image_screenshot_path.gsub! '/spec', '/ws/spec'
        html_screenshot_path.gsub! '/home/jenkins/workspace/', 'http://ci.gallerydev.net:8080/job/'
        html_screenshot_path.gsub! '/spec', '/ws/spec'
        results.gsub! '/home/jenkins/workspace/', 'http://ci.gallerydev.net:8080/job/'
        results.gsub! '/spec', '/ws/spec'
      end

      if image_screenshot_path.include? "/vol/jenkins/jobs/"
        image_screenshot_path.gsub! '/vol/jenkins/jobs/', 'http://ci.gallerydev.net:8080/job/'
        image_screenshot_path.gsub! '/workspace/spec', '/ws/spec'
        html_screenshot_path.gsub! '/vol/jenkins/jobs/', 'http://ci.gallerydev.net:8080/job/'
        html_screenshot_path.gsub! '/workspace/spec', '/ws/spec'
        results.gsub! '/vol/jenkins/jobs/', 'http://ci.gallerydev.net:8080/job/'
        results.gsub! '/workspace/spec', '/ws/spec'
      end

      if image_screenshot_path.include? "/var/lib/jenkins/workspace/"
        image_screenshot_path.gsub! '/var/lib/jenkins/workspace/', 'http://smithers.vidmark.local/job/'
        image_screenshot_path.gsub! '/spec', '/ws/spec'
        html_screenshot_path.gsub! '/var/lib/jenkins/workspace/', 'http://smithers.vidmark.local/job/'
        html_screenshot_path.gsub! '/spec', '/ws/spec'
        results.gsub! '/var/lib/jenkins/workspace/', 'http://smithers.vidmark.local/job/'
        results.gsub! '/spec', '/ws/spec'
      end

      puts "...Exception at current URL: #{current_url}"
      puts "...Image Screenshot: #{image_screenshot_path}"
      puts "...Html Screenshot: #{html_screenshot_path}"
      puts "...Click only for Single Process Results: #{results}"

      if Capybara.current_driver == :poltergeist
        puts "...Network traffic:"
        Capybara.current_session.driver.browser.network_traffic.each do |request|
          request.response_parts.uniq(&:url).each do |response|
            if response.status != nil && response.status > 308
              puts "#{response.url}: #{response.status} - #{response.status_text}, #{response.time}"
            end
          end
        end
        if File.zero?("phantomjs_console.log")
          File.open("phantomjs_console.log", "r").readlines.each do |line|
            warn "...Console error: #{line}" if line.match(/error/i)
          end
        end
      end
    end
    # show console errors even when example completed without error
    if Capybara.current_driver == :poltergeist
      Capybara.reset_session!
      # Capybara.current_session.driver.quit
      if File.zero?("phantomjs_console.log")
        File.open("phantomjs_console.log", "r").readlines.each do |line|
          warn "...Console error: #{line}" if line.match(/error/i)
        end
      end
    else
      Capybara.reset_session!
      Capybara.current_session.driver.quit
    end
  end
end

SitePrism.configure do |config|
  config.use_implicit_waits = true # enable implicit waits for the has_ and has_no_ methods in SitePrism
end

def open_screenshot
  screenshot_path = File.join(File.dirname(__FILE__),"screenshots/capybara-screenshot.png")
  page.save_screenshot(screenshot_path, :full => true)
  Launchy.open(screenshot_path)
end
