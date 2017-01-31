class SourcesController < ApplicationController
  helper_method :get_source_timer

  def index
    @articles = current_user.articles.order(pub_date: :DESC).page(params[:page]).per(12)
  end

  def new
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
    elsif current_user.sources.count > 24
      flash[:alert] = "Error :  You have reached the fair use of 25 RSS feeds"
    else
      begin
         RSS::Parser.parse(@source.url, do_validate=true, ignore_unknown_element=true)
        @source.name = @source.url
        get_source_name(@source.name)
        @source.save
        flash[:notice] = @source.name + " added"
      rescue
        flash[:alert] = "Error : #{@source.url} is not a valid RSS feed"
      end
    end
    update
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

  def get_source_name(url)
    url.slice!("http://")
    url.slice!("https://")
    url.slice!("/feed/")
    url.slice!("/feed")
    url.slice!("www.")
    url.slice!("www2.")
    url.slice!("page=")
    url.slice!("backend")
    url.slice!("spip")
    url.slice!(".php")
    url.slice!("/")
    url.slice!("?")
  end

  def get_source_timer(article)
    now = DateTime.now
    pubdate = DateTime.parse(article.pub_date.to_s)
    time = (now - pubdate).to_f * 24
    if time == 0
      day = "Just now"
    elsif time < 24
      day = time.round.to_s + " hours"
    else  time >= 24
      day = " Yesterday"
    end
  end


end
