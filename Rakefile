require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'benchmark'  
Rails.application.load_tasks


# namespace :assets  do
#   desc 'preparing config files...'
#   task :publish_my_holy_shinning_precompiled_miraculous_assets_to_the_almighty_upyun do
#       #RailsAssetsForUpyun.publish 'threejed-ass', 'zhangruihailang', '090125lz'
#       RailsAssetsForUpyun.publish('threejed-ass', 'zhangruihailang', '090125lz', bucket_path="/", localpath='public/assets/', upyun_ap="http://v0.api.upyun.com")
#   end
# end

namespace :spider  do
  desc '智乐园 教育知识'
  task :zhileyuan_jiaoyuzhishi, [:class_id] => :environment do |t, args|
  
    threads = []
    channels = []
    threads << Thread.new { 
      hrefs = Array.new
      agent = Mechanize.new
      
      url = "http://www.zhly.cn/family/jyzs/index/page/"
      # total_page = args[:total_page].to_i
      class_id = args[:class_id].to_i
      (30..45).to_a.reverse.each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get(real_url)
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
        hrefs << link
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        position = content_page.css("[class='position']")[0]
        if !position.nil? && position.content.include?('当前位置：首页>家庭教育>教育知识')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .sub("更多中小学教育资讯请点击：","")
          .sub("http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          # channel.channel_class_id = 3
          channel.channel_class_id = class_id
          channels << channel
          p 'total_size='+channels.length.to_s
          #channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
        end
      end
    end 
    }
    threads << Thread.new { 
    hrefs = Array.new
      agent = Mechanize.new
      
      url = "http://www.zhly.cn/family/jyzs/index/page/"
      # total_page = args[:total_page].to_i
      class_id = args[:class_id].to_i
    (15..30).to_a.reverse.each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get(real_url)
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
        hrefs << link
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        position = content_page.css("[class='position']")[0]
        if !position.nil? && position.content.include?('当前位置：首页>家庭教育>教育知识')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .sub("更多中小学教育资讯请点击：","")
          .sub("http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          # channel.channel_class_id = 3
          channel.channel_class_id = class_id
          channels << channel
          p 'total_size='+channels.length.to_s
          #channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
        end
      end
    end 
    }
    threads << Thread.new {
    hrefs = Array.new
      agent = Mechanize.new
      
      url = "http://www.zhly.cn/family/jyzs/index/page/"
      # total_page = args[:total_page].to_i
      class_id = args[:class_id].to_i
    (1..15).to_a.reverse.each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get(real_url)
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
        hrefs << link
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        position = content_page.css("[class='position']")[0]
        if !position.nil? && position.content.include?('当前位置：首页>家庭教育>教育知识')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .sub("更多中小学教育资讯请点击：","")
          .sub("http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          # channel.channel_class_id = 3
          channel.channel_class_id = class_id
          channels << channel
          p 'total_size='+channels.length.to_s
          #channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
        end
      end
    end 
    }

    threads.each { |t| t.join }
    channels.each {|channel| channel.save}
    
  end
end


namespace :spider  do
  desc '智乐园 教育理念'
  task :zhileyuan_jiaoyulinian, [:class_id] => :environment do |t, args|
    hrefs = Array.new
    agent = Mechanize.new
    url = "http://www.zhly.cn/family/jyln/index/page/"
    # total_page = args[:total_page].to_i
    class_id = args[:class_id].to_i
    (1..77).each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get(real_url)
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
        hrefs << link
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        position = content_page.css("[class='position']")[0]
        if !position.nil? && position.content.include?('当前位置：首页>家庭教育>教育理念')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .sub("更多中小学教育资讯请点击：","")
          .sub("http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          # channel.channel_class_id = 3
          channel.channel_class_id = class_id
          channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
        end
      end
    end 
  end
end



namespace :spider  do
  desc '智乐园 生理健康'
  task :zhileyuan_shenglijiankang, [:class_id] => :environment do |t, args|
  
    threads = []
    channels = []
    threads << Thread.new { 
      hrefs = Array.new
      agent = Mechanize.new
      
      url = "http://www.zhly.cn/family/sljk/index/page/"
      # total_page = args[:total_page].to_i
      class_id = args[:class_id].to_i
      (30..45).to_a.reverse.each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get(real_url)
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
        hrefs << link
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        position = content_page.css("[class='position']")[0]
        if !position.nil? && position.content.include?('当前位置：首页>家庭教育>生理健康')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .sub("更多中小学教育资讯请点击：","")
          .sub("http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          # channel.channel_class_id = 3
          channel.channel_class_id = class_id
          channels << channel
          p 'total_size='+channels.length.to_s
          #channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
        end
      end
    end 
    }
    threads << Thread.new { 
    hrefs = Array.new
      agent = Mechanize.new
      
      url = "http://www.zhly.cn/family/sljk/index/page/"
      # total_page = args[:total_page].to_i
      class_id = args[:class_id].to_i
    (15..30).to_a.reverse.each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get(real_url)
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
        hrefs << link
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        position = content_page.css("[class='position']")[0]
        if !position.nil? && position.content.include?('当前位置：首页>家庭教育>生理健康')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .sub("更多中小学教育资讯请点击：","")
          .sub("http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          # channel.channel_class_id = 3
          channel.channel_class_id = class_id
          channels << channel
          p 'total_size='+channels.length.to_s
          #channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
        end
      end
    end 
    }
    threads << Thread.new {
    hrefs = Array.new
      agent = Mechanize.new
      
      url = "http://www.zhly.cn/family/sljk/index/page/"
      # total_page = args[:total_page].to_i
      class_id = args[:class_id].to_i
    (1..15).to_a.reverse.each do |i|
      real_url = url + i.to_s
      p "---------------------list_url:#{real_url}------------------"
      page = agent.get(real_url)
      page.links.each do |link|

      if !link.href.nil? && link.href.include?('/family/index/content/id/') && !hrefs.include?(link.href)
        hrefs << link
        title = link.text
        p "---------------------content_url:#{link.href}------------------"
        content_page = link.click
        position = content_page.css("[class='position']")[0]
        if !position.nil? && position.content.include?('当前位置：首页>家庭教育>生理健康')
          # pp 'position================='+position
          intro = content_page.css("[class='zyContent']")[0].content
          content = content_page.css("[class='arti_artile']")[0].content
          channel = Channel.new
          channel.title = title
          channel.intro = intro
          channel.content = content.gsub(/\n/,"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .sub("更多中小学教育资讯请点击：","")
          .sub("http://www.zhly.cn/education","")
                                  # .gsub(/\t/,"&nbsp;&nbsp;&nbsp;&nbsp;")
                                   
          channel.user_id = 2
          # channel.channel_class_id = 3
          channel.channel_class_id = class_id
          channels << channel
          p 'total_size='+channels.length.to_s
          #channel.save
        end
        # pp 'title='+title
        # pp 'intro='+intro
        # pp 'content='+content
        end
      end
    end 
    }

    threads.each { |t| t.join }
    channels.each {|channel| channel.save}
    
  end
end