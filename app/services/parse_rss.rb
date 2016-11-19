require 'rss'
class ParseRss < ServiceBase

  attr_accessor :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def run
    get_rss
  end

  private

  def get_rss
    @sources = @current_user.sources.all
    @sources.each do |source|
      rss = RSS::Parser.parse(source.url, false)
      if rss
        case rss.feed_type
          when 'rss'
            rss.items.each do |item|
              unless source.articles.find_by(url: item.link)
                source.articles.create(
                  title: item.title,
                  url:item.link,
                  excerpt: Sanitize.fragment(item.description.split.slice(0, 100).join(" ")),
                  pub_date: item.pubDate)
              end
            end
          when 'atom'
            rss.items.each do |item|
              unless item.url == source.articles.find_by(url: item.url.content)
                source.articles.create(
                  title: item.title.content,
                  url: item.url.content,
                  excerpt: Sanitize.fragment(item.description.content.split.slice(0, 100).join(" ")),
                  pub_date: item.pubDate.content )
              end
            end
        end
      end
    end
  end

end
