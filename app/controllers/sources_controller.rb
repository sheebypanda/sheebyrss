require 'rss'

class SourcesController < ApplicationController
  def index
    @sources = current_user.sources.all
    @sources.each do |source|
      source.articles.destroy_all
      rss = RSS::Parser.parse(source.url, false)
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
    end
  end
  def new
    @source = current_user.sources.new
  end
  def create
    @source = current_user.sources.new(source_url)
    if @source.save
      flash[:notice] = @source.url + " added"
      redirect_to sources_path
    else
      flash[:alert] = "Error : #{@source.url} not added"
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
