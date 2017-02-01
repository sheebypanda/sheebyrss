require 'rss/dublincore'
class ParseRss < ApplicationController

  attr_accessor :current_user, :source_url, :flash

  def initialize(current_user)
    @current_user = current_user
  end

  def get_rss(source_url)
    begin
      rss = RSS::Parser.parse(source_url.url, false)
    rescue
      flash[:alert] = "Network error : #{source_url.url} count not be reached"
    end
  end

  def get_articles(source_url)
    rss = get_rss(source_url)
    case rss.feed_type
      when 'rss'
        rss.items.each do |item|
          unless source_url.articles.find_by(url: item.link)
            if item.description
              descr = Sanitize.fragment(item.description.split.slice(0, 100).join(" "))
            else
              descr = nil
            end
            if item.pubDate
              date = item.pubDate
            elsif item.dc_date
              date = item.dc_date
            else
              date = DateTime.now
            end
            begin
                 source_url.articles.create(
                   title: item.title,
                   url:item.link,
                   excerpt: descr,
                   pub_date: date)
            rescue
              flash[:alert] = "Error when trying to get articles from rss feed #{source_url.url}"
            end
          end
        end
      when 'atom'
        rss.items.each do |item|
          unless item.url == source_url.articles.find_by(url: item.url.content)
            if item.description.content
              descr = Sanitize.fragment(item.description.content.split.slice(0, 100).join(" "))
            else
              descr = nil
            end
            begin
              source_url.articles.create(
                title: item.title.content,
                url: item.url.content,
                excerpt: descr,
                pub_date: item.pubDate.content )
            rescue
              flash[:alert] = "Error when trying to get articles from atom feed #{source_url.url}"
            end
          end
        end
      end
    end
  end
