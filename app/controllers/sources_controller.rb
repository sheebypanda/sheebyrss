require 'rss'

class SourcesController < ApplicationController
  def index
    @sources = current_user.sources.all
    @source = current_user.sources.new
    end
  end

  def new
  end

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

  def create
    @source = current_user.sources.new(source_url)
    rss = RSS::Parser.parse(@source.url, false)
    if rss and @source.save
      flash[:notice] = @source.url + " added"
      redirect_to sources_path
    else
      flash[:alert] = "Error : #{@source.url} is not a valid RSS feed"
      redirect_to sources_path
    end
  end

  def destroy
    @source = current_user.sources.find(params[:id])
    if @source.destroy
      flash[:notice] = "#{@source.url} successfully deleted"
    else
      flash[:alert] = "Error : #{@source.url} not deleted"
    end
    redirect_to sources_path
  end

  private

  def source_url
    params.require(:source).permit(:url, :source_id)
  end
  def get_rss(url)
    rss = RSS::Parser.parse(url, false)
    case rss.feed_type
      when 'rss'
        @articlestitles = []
        rss.items.each do |item|
          @articlestitles << item.title
        end
      when 'atom'
        rss.items.each do |item|
          @articlestitles << item.title.content
        end
    end
  end
end
