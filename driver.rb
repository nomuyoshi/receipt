require 'selenium-webdriver'

def driver
  options = Selenium::WebDriver::Chrome::Options.new
  # FIXME: --no-sandbox なしにできるようにする
  options.add_argument('--no-sandbox')
  options.add_argument('--headless')

  driver = Selenium::WebDriver.for :chrome, options: options
  driver.manage.timeouts.implicit_wait = 10
  return driver
end
