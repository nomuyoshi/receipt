# 実行例
# ruby mineo.rb 202101 202102 202103 202104
require 'selenium-webdriver'
require "./driver.rb"
require "./config.rb"
require "./helper.rb"

year_months = []
ARGV.each do |arg|
  year_months << arg
end

if year_months.empty?
  puts "請求年月を選択してください。例: ruby mineo.rb 202101 202102 202103" 
  return
end

config = AppConfig.load.mineo
driver = build_driver()

begin
  driver.get(config.login_url)
  # ID入力
  driver.find_element(id: "eoID").send_keys(config.id)
  driver.find_element(id: "btnSubmit").click

  # PASS入力
  driver.find_element(id: "password").send_keys(config.password)
  driver.find_element(id: "btnSubmit").click

  sleep 1
  # 請求内訳ページに遷移
  driver.get(config.billing_url)
  # 要素取得することでページ遷移完了するまで待機（最大10s）
  driver.find_element(id: "billingYm")

  puts "[マイネオ] DL開始"
  year_months.each do |year_month|
    # セレクトボックスで該当の年月を選択
    select_elem = driver.find_element(id: "billingYm")
    Selenium::WebDriver::Support::Select.new(select_elem).select_by(:value, year_month.to_s)
    # 請求年月を選択したら、なにやらPOSTして請求情報を取得している？
    # 一度リロードされるので、すぐにDLボタンをクリックできない(すぐにクリックすると請求年月が反映されない)
    sleep 2
    # DLボタンクリック
    driver.find_element(id: "pdfDownload").click

    # DL完了したら次へ。失敗したらログ出して次へ
    if Helper.download_success?("Uchiwake_*_#{year_month}.pdf")
      puts "[マイネオ] #{year_month}完了"
      next
    else
      puts "Error: [マイネオ] DL未完了 年月: #{year_month}"
    end
  end
ensure
  # ドライバーを閉じる
  driver.quit
end
