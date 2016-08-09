class SourcesController < ApplicationController
  def index
    @sources = current_user.sources.all
  end

  def new
    @source = current_user.sources.new
  end

  def create
    @source = current_user.sources.new(source_params)
    if @source.save
      flash[:notice] = @source.url + " added"
      redirect_to sources_path
    else
      flash[:alert] = "Error : #{@source.url} not added"
    end
  end

  def destroy
    source = current_user.sources.find(params[:id])
    if source.destroy
      flash[:notice] = "Source successfully deleted"
    else
      flash[:alert] = "Error : Source not deleted"
    end
    redirect_to sources_path
  end

  private

  def source_params
    params.require(:source).permit(:url, :source_id)
  end

end
