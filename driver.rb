require 'selenium-webdriver'

def build_driver
  config = AppConfig.load.global
  args = ["--headless"]
  prefs = {
    "download" => {
      "default_directory" => config.download_dir,
      "prompt_for_download" => false, # ダウンロード前に各ファイルの保存場所を確認する OFF
    }
  }

  options = Selenium::WebDriver::Chrome::Options.new(args: args, prefs: prefs)
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.manage.timeouts.implicit_wait = 10
  return driver
end
