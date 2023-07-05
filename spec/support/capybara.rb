require 'capybara/rspec'

Capybara.server = :webrick

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox disable-gpu window-size=1280,1024]
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options:
  )
end

Capybara.javascript_driver = :headless_chrome
