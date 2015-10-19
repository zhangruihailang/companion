class SpiderController < ApplicationController
  require 'rubygems'
  require 'mechanize'
  require 'open-uri'
  # def test
  
  #   agent = Mechanize.new
  #   page = agent.get('http://yoparent.cn/archives/tag/%E6%99%BA%E5%95%86')
  #   # pp page
  #   page.links_with(:text => 'Continue Reading').each do |link|

  #   pp link.href
  #   channel = Channel.new
  #   content_page = link.click   
  #   # pp content_page
  #   # p "----------------------11111111111111---------------------------"
  #   content_page.css('article header').each do |f|
  #     title = f.content.chomp.reverse.chomp.reverse
  #     #p title
  #     channel.title = title
  #   end
  #   #p "-------------------------------------------------"
  #   f = content_page.css('section')[2]
  #   content = f.content.gsub(/\n/,"<br/>").gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
  #   #p "------------------content#{content}-------------------------------"
  #   #pp f.content
  #   channel.intro = f.content[0,100] + '...'
  #   channel.content = content
  #   channel.user_id = 2
  #   file_name = "./channel.jpg"  
  #   file = File.new("#{file_name}")
  #   channel.picture = file
  #   channel.save
  # # p "----------------------11111111111111---------------------------"

  #   end


  # end
  
  def test
    hrefs = Array.new
    agent = Mechanize.new
    url = "http://www.zhly.cn/family/jyln/index/page/"
    (1..1).each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get('http://www.zhly.cn/family/jyln')
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
         hrefs << link
        # pp link.href
        
        
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        
        
        position = content_page.css("[class='position']")[0]
        # pp 'position='+position
          
        if position.content.include?('当前位置：首页>家庭教育>教育理念')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;").sub("更多中小学教育资讯请点击：http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          channel.channel_class_id = 3
          channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
       end
    
      end
    end
    
    
    # page = agent.get('http://www.zhly.cn/family/jyln')
    # page.links.each do |link|

    #   if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
    #     hrefs << link
    #     pp link.href
    #     content_page = link.click
    #     f = content_page.css("[class='zyContent']")[0]
    #     pp f.content
    #   end
    
    # end
    
    
    
    
    # hrefs.each do  |herf|
    #   # channel = Channel.new
    #   content_page = herf.click   
    #   f = content_page.css("[class='zyContent']")[0]
    #   pp f.content
      
    #   # pp content_page
    # end 
    # channel = Channel.new
    # content_page = link.click   
    # pp content_page
    # p "----------------------11111111111111---------------------------"
    # content_page.css('article header').each do |f|
    #   title = f.content.chomp.reverse.chomp.reverse
    #   #p title
    #   channel.title = title
    # end
    #p "-------------------------------------------------"
    # f = content_page.css('section')[2]
    # content = f.content.gsub(/\n/,"<br/>").gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
    # #p "------------------content#{content}-------------------------------"
    # #pp f.content
    # channel.intro = f.content[0,100] + '...'
    # channel.content = content
    # channel.user_id = 2
    # file_name = "./channel.jpg"  
    # file = File.new("#{file_name}")
    # channel.picture = file
    # channel.save
  # p "----------------------11111111111111---------------------------"

    # end
  end
  
  
end
