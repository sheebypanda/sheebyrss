require 'rss'
class ParseRss < ServiceBase

  attr_accessor :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def run
    get_rss
    end
  end

  private

  def get_rss
    @sources = @current_user.sources.all
    @sources.each do |source|
      source.articles.destroy_all
      rss = RSS::Parser.parse(source.url, false)
      if rss
        case rss.feed_type
          when 'rss'
            rss.items.each do |item|
              source.articles.create(
                title: item.title,
                url:item.link,
                excerpt: Sanitize.fragment(item.description),
                pub_date: item.pubDate)
            end
          when 'atom'
            rss.items.each do |item|
              source.articles.create(
              title: item.title.content,
              url: item.url.content,
              excerpt: Sanitize.fragment(item.description.content),
              pub_date: item.pubDate.content
               )
            end
        end
      else
        flash[:alert] = "Error : #{source.url} can not be loaded"
      end
    end
  end
