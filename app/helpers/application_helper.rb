module ApplicationHelper
  require 'net/http'
  require 'open-uri'
  
  def full_title(page_title='')
    base_title ="三晋E贷"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  def get_badge_style
    num = rand(100)
    if num % 5 == 0
      'am-badge-primary'
    elsif num % 5 == 2
      'am-badge-secondary'
    elsif num % 5 == 3
      'am-badge-success'
    elsif num % 5 == 4
      'am-badge-warning'
    else num % 5 == 1
      'am-badge-danger'
    end
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
  
  def get_file_from_wexin(access_token,media_id)
    url_path = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=#{access_token}&media_id=#{media_id}"  
    path = "/cgi-bin/media/get?access_token=#{access_token}&media_id=#{media_id}"
    url = URI.parse(url_path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get(path)
    }
          
    str = res.body
    file_name = "./#{SecureRandom.uuid.gsub("-","")}.jpg"  
    open("#{file_name}", "wb") { |file|
      file.write(res.body)
      return file_name
    }
    
  end
  
end
