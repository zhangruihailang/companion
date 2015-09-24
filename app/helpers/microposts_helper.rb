module MicropostsHelper
  
  def time_ago_in_words_cn(time)
    time_ago_in_words(time)
    .sub('seconds','秒')
    .sub('minutes','分钟')
    .sub('hours','小时')
    .sub('days','天')
    .sub('months','个月')
    .sub('years','个月')
    .sub('a second','1秒')
    .sub('a minute','1分钟')
    .sub('an hour',' 1小时')
    .sub('a day','1天')
    .sub('a month','1个月')
    .sub('a year','1年')
    .sub('second','秒')
    .sub('minute','分钟')
    .sub('hour','小时')
    .sub('day','天')
    .sub('month','个月')
    .sub('year','年')
    .sub('about','')
    .sub('less than','')
  end
  
  def get_weixin_js
      #如果有GET请求参数直接写在URI地址中  
    url = URI.parse('http://www.charmdate.cn:9090/Charm/upload/weixin_js.jsp')
    path = "/Charm/upload/weixin_js.jsp"
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
  
  def get_access_token
    url = URI.parse('http://www.charmdate.cn:9090/Charm/upload/weixin_token.jsp')
    path = "/Charm/upload/weixin_token.jsp"
    https = Net::HTTP.new(url.host,url.port)
    https.use_ssl = false    
    # req = Net::HTTP::Post.new(path，{'url' => request.url})
    req = Net::HTTP::Post.new("#{path}?url=#{request.url}")
    #data =	"<?xml version='1.0' encoding='utf-8'?><templateSMS><appId>ae84fc15535a411093ff63b830969509</appId><templateId>4892</templateId><to>#{params[:mobile]}</to><param>#{@smscode}</param></templateSMS>"
    # req.body = data
    res = https.request(req)
    puts "---------------------body:#{res.body}-------------------"
    return res.body.gsub(/\s+/,'')#.sub('debug: false','debug: true')
  end
  
end
