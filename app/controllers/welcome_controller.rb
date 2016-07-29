class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @source = Source.new()
  end
  def create
    @source.save
  end

  private

  def source_url
    params.require(:source).permit(:url)
  end
end
