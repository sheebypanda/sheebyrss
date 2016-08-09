class SourcesController < ApplicationController
  def index
    @sources = current_user.sources.all
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
  end
end
