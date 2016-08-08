class AddUserRefToSources < ActiveRecord::Migration
  def change
    add_reference :sources, :user, index: true, foreign_key: true
  end
end
