class CreateBookEditions < ActiveRecord::Migration[5.1]
  def change
    create_table :book_editions do |t|
      t.integer :contract_link, null: false

      t.text :title, null: false
      t.text :isbn10, null: false
      t.text :isbn13, null: false

      t.integer :edition
      t.integer :binding

      t.text :author
      t.text :description

      t.date :publish_date
      t.integer :price

      t.integer :width
      t.integer :height
      t.integer :depth

      t.boolean :deleted, null: false
      t.timestamps
    end

    add_index(:book_editions, :contract_link, unique: true)
    add_index(:book_editions, :title)
    add_index(:book_editions, :author)
    add_index(:book_editions, :description)

    add_index(:book_editions, %i[isbn10 isbn13])
    add_index(:book_editions, :isbn13)
  end
end
