class UrlDisplay < ServiceBase

    attr_accessor :current_user, :articles

    def initialize(current_user, articles)
      @current_user = current_user
      @articles = articles
    end

  def run
    url_display
  end

  private

    def url_display
      @articles.each do |article|
        article.url.slice!("http://")
        article.url.slice!("/feed/")
        article.url.slice!("/feed")
        article.url.slice!("www.")
        article.save
      end
    end
end
