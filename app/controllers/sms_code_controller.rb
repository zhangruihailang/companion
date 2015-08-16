class SmsCodeController < ApplicationController
  
  def send_code
     p "---------------------------------------------------------"
    sig = Digest::MD5.hexdigest(("439c50e3ccf174139c13def5a00be034"+"49ee5da5489b144012728f719ae506a7"+DateTime.parse(Time.now.to_s).strftime('%Y%m%d%H%M%S').to_s)).upcase
    url = URI.parse("https://api.ucpaas.com/2014-06-30/Accounts/439c50e3ccf174139c13def5a00be034/Messages/templateSMS.xml?sig=#{sig}")
    path = "/2014-06-30/Accounts/439c50e3ccf174139c13def5a00be034/Messages/templateSMS.xml?sig=#{sig}"
    https = Net::HTTP.new(url.host,url.port)
    https.use_ssl = true    
    authorization = Base64.strict_encode64("439c50e3ccf174139c13def5a00be034"+":"+DateTime.parse(Time.now.to_s).strftime('%Y%m%d%H%M%S').to_s)
    req = Net::HTTP::Post.new(path,{'Content-Type' => 'application/xml;charset=utf-8','Accept' => 'application/xml','Authorization' => "#{authorization}"})
    data =	"<?xml version='1.0' encoding='utf-8'?><templateSMS><appId>ae84fc15535a411093ff63b830969509</appId><templateId>4892</templateId><to>15035135243</to><param>1234</param></templateSMS>"
    req.body = data
    res = https.request(req)

    puts "------------------------receive----#{res.body}-----------------------------------------------"
    render(:nothing=>true) 
  end
  
 
  

end