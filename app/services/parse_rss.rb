require 'rss'

class ParseRss < ServiceBase

  def update
    @sources = current_user.sources.all
    @sources.each do |source|
    source.articles.destroy_all
    rss = RSS::Parser.parse(source.url, false)
    if rss
      case rss.feed_type
        when 'rss'
          rss.items.each do |item|
            source.articles.create(title: item.title, url:item.link)
          end
        when 'atom'
          rss.items.each do |item|
            source.articles.create(title: item.title.content, url: item.url.content )
          end
      end
    else
      flash[:alert] = "Error : #{source.url} can not be loaded"
    end
  end

end