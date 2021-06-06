module Helper
  MAX_DL_CHECK_NUM = 100

  def self.download_success?(file_pattern)
    dir = AppConfig.load.global.download_dir
    finished = false
    num = 0

    until num > MAX_DL_CHECK_NUM  do
      result = Dir.glob("#{dir}/#{file_pattern}")
      if result.size > 0
        finished = true
        break
      end

      sleep 0.5
    end

    finished
  end
end
