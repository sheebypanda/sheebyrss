class SourcesController < ApplicationController
  def index
    @articles = current_user.articles.order(pub_date: :DESC)
    @source = current_user.sources.new
  end
  def update
    ParseRss.run(current_user)
    redirect_to sources_path
  end
  def create
    @source = current_user.sources.new(source_url)
    if current_user.sources.find_by(source_url)
      flash[:alert] = "Error :  #{@source.url} already added"
      redirect_to sources_path
    else
      if RSS::Parser.parse(@source.url, false) and @source.save
        update
        flash[:notice] = @source.url + " added"
        redirect_to sources_path
      else
        flash[:alert] = "Error : #{@source.url} is not a valid RSS feed"
        redirect_to sources_path
      end
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
