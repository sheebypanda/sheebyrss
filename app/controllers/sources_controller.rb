class SourcesController < ApplicationController
  def index
    @sources = current_user.sources.all
    @source = current_user.sources.new
  end
  def update_all
    ParseRss.run(current_user)
  end
  def update(source_id)
    ParseRss.run(current_user, source_id)
  end
  def create
    @source = current_user.sources.new(source_url)
    rss = RSS::Parser.parse(@source.url, false)
    if rss and @source.save
      update(current_user, @source.id)
      flash[:notice] = @source.url + " added"
      redirect_to sources_path
    else
      flash[:alert] = "Error : #{@source.url} is not a valid RSS feed"
      redirect_to sources_path
    end
  end
  def destroy
    get_source
    if @source.destroy
      flash[:notice] = "#{@source.url} successfully deleted"
    else
      flash[:alert] = "Error : #{@source.url} not deleted"
    end
    redirect_to root_path
  end

  private

  def source_url
    params.require(:source).permit(:url, :source_id)
  end
  def get_source
    @source = current_user.sources.find(params[:id])
  end

end
