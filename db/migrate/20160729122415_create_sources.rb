class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :url

      t.timestamps null: false
    end
  end
end
