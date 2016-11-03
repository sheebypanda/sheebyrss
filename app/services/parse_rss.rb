require 'rss'
class ParseRss < ServiceBase

  attr_accessor :current_user

  def initialize(current_user, source_id)
    @current_user = current_user
    @source = Source.find(source_id)
  end

  def run
    if @source
      get_rss(@source)
    else
      get_all_rss
    end
  end

  private

  def get_all_rss
    @sources = @current_user.sources.all
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

  def get_rss(source)
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
