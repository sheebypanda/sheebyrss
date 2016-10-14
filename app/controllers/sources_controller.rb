class SourcesController < ApplicationController
  def index
    @sources = current_user.sources.all
    @source = current_user.sources.new
  end

  def new
  end

  def update
    ParseRss.new(self).update
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
end
