class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.decimal :price
      t.string :title
      t.boolean :published
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
