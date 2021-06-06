require 'selenium-webdriver'
require "./driver.rb"
require "./config.rb"

year_months = []
ARGV.each do |arg|
  year_months << arg
end

driver = driver()
config = AppConfig.load.mineo

driver.get(config.login_url)

# ID入力
driver.find_element(id: "eoID").send_keys(config.id)
driver.find_element(id: "btnSubmit").click

# PASS入力
driver.find_element(id: "password").send_keys(config.password)
driver.find_element(id: "btnSubmit").click

# 請求内訳ページに遷移
driver.navigate().to(config.billing_url)
# 請求書の年月選択のセレクトボックス取得
select_elem = driver.find_element(id: "billingYm")

year_months.each do |year_month|
  # セレクトボックスで該当の年月を選択
  Selenium::WebDriver::Support::Select.new(select_elem).select_by(:value, year_month.to_s)
  # DLボタンクリック
  driver.find_element(id: "pdfDownload").click
  # TODO: DL完了を検知できるようにする
  sleep 5
end

# ドライバーを閉じる
driver.quit
