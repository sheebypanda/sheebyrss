require 'rss/dublincore'
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
                  source.articles.create(
                    title: item.title,
                    url:item.link,
                    excerpt: descr,
                    pub_date: date)
                rescue
                  flash[:alert] = "Error : #{@source.url} is not a valid RSS feed"
                end
              end
            end
          when 'atom'
            rss.items.each do |item|
              unless item.url == source.articles.find_by(url: item.url.content)
                if item.description.content
                  descr = Sanitize.fragment(item.description.content.split.slice(0, 100).join(" "))
                else
                  descr = nil
                end
                begin
                  source.articles.create(
                    title: item.title.content,
                    url: item.url.content,
                    excerpt: descr,
                    pub_date: item.pubDate.content )
                  rescue
                    flash[:alert] = "Error : #{@source.url} is not a valid atom feed"
                  end
              end
            end
        end
      end
    end
  end

end
