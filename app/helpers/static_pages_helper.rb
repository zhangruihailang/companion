module StaticPagesHelper
  def test_upload
   #如果有GET请求参数直接写在URI地址中  
    url = URI.parse('http://www.charmdate.cn:9090/Charm/upload/weixin.jsp')
    path = "/Charm/upload/weixin.jsp"
    https = Net::HTTP.new(url.host,url.port)
    https.use_ssl = false    
    # req = Net::HTTP::Post.new(path，{'url' => request.url})
    req = Net::HTTP::Post.new("#{path}?url=#{request.url}")
    #data =	"<?xml version='1.0' encoding='utf-8'?><templateSMS><appId>ae84fc15535a411093ff63b830969509</appId><templateId>4892</templateId><to>#{params[:mobile]}</to><param>#{@smscode}</param></templateSMS>"
    # req.body = data
    res = https.request(req)
    puts "---------------------body:#{res.body}-------------------"
    return res.body.sub('debug: false','debug: true')
  end
end
