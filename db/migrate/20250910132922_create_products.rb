class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.text :description
      t.string :price
      t.string :url, null: false
      t.string :contact
      t.string :size
      t.references :category, foreign_key: true
      t.datetime :scraped_at
      t.timestamps
    end
  end
end
