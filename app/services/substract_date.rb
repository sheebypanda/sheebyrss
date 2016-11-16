class SubstractDate < ServiceBase

  attr_accessor :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def run
    get_rss
    end
  end

  private

  def get_rss

    end
  end
