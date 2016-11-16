class UrlDisplay < ServiceBase

  attr_accessor :articles

  def initialize(articles)
    @articles = articles
  end

  def run
    @articles.each do |article|
      article.url.slice!("http://")
      article.url.slice!("/feed/")
      article.url.slice!("/feed")
      article.url.slice!("www.")
    end
  end

end
