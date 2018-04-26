class RenameDeleteFieldFromBookEdition < ActiveRecord::Migration[5.2]
  def change
    rename_column(:book_editions, :deleted, :removed)
  end
end
