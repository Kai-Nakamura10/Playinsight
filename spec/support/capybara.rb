require 'capybara/rspec'

Capybara.register_driver :selenium_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--window-size=1400,900')
  options.add_argument('--headless') if ENV['HEADLESS'] == 'true'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :selenium_chrome
