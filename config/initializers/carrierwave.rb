CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = "zhangruihailang"
  config.upyun_password = '090125lz'
  config.upyun_bucket = "threejed"
  #config.upyun_bucket_domain = "threejed.b0.upaiyun.com"
  config.upyun_bucket_host = "threejed.b0.upaiyun.com"
end