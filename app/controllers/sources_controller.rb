class SourcesController < ApplicationController
  def index
    @sources = current_user.sources
  end

  def new
    @source = Source.new
  end

  def create
    current_user.source.create(source_url)
  end
  
  def destroy
  end

  private

  def source_url
    params.require(:source).permit(:url)
  end

end
