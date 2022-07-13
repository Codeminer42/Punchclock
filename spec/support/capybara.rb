require 'capybara/rspec'

Capybara.server = :webrick

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions": {  args: %w[no-sandbox headless disable-gpu window-size=1280,1024] }
  )

  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless no-sandbox disable-gpu]
  )


  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    capabilities: capabilities,
    options: options
  )
end

Capybara.javascript_driver = :headless_chrome
