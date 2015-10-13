class SpiderController < ApplicationController
  require 'rubygems'
  require 'mechanize'
  require 'open-uri'
  def test
  
    agent = Mechanize.new
    page = agent.get('http://yoparent.cn/archives/tag/%E6%99%BA%E5%95%86')
    # pp page
    page.links_with(:text => 'Continue Reading').each do |link|

    pp link.href
    channel = Channel.new
    content_page = link.click   
    # pp content_page
    # p "----------------------11111111111111---------------------------"
    content_page.css('article header').each do |f|
      title = f.content.chomp.reverse.chomp.reverse
       #p title
      channel.title = title
    end
    #p "-------------------------------------------------"
    f = content_page.css('section')[2]
    content = f.content.gsub(/\n/,"<br/>").gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
    #p "------------------content#{content}-------------------------------"
    #pp f.content
    channel.intro = f.content[0,100] + '...'
    channel.content = content
    channel.user_id = 2
    file_name = "./channel.jpg"  
    file = File.new("#{file_name}")
    channel.picture = file
    channel.save
  # p "----------------------11111111111111---------------------------"

    end


  end
end
