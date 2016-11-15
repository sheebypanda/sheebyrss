class AddPubdateToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :pub_date, :datetime
  end
end
