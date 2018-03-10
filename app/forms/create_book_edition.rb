class CreateBookEdition < ApplicationForm
  attr_reader :book_edition

  attribute :title, String
  attribute :isbn10, String
  attribute :isbn13, String
  attribute :contract_link, Integer
  attribute :edition, Integer
  attribute :binding, Integer
  attribute :deleted, Boolean

  attribute :author, String
  attribute :description, String
  attribute :publish_date, Date
  attribute :price, Integer

  attribute :height, Integer
  attribute :width, Integer
  attribute :depth, Integer

  validates :title, :isbn10, :isbn13, :contract_link, presence: true
  validates :deleted, inclusion: { in: [true, false] }
  validates :isbn10, length: { is: 10 }
  validates :isbn13, length: { is: 13 }
  validates :height, :width, :depth,  numericality: { greater_than_or_equal: 0 }, allow_nil: true

  private

  def persist!
    @book_edition = BookEdition.create!(attributes)
  rescue ActiveRecord::RecordInvalid => invalid
    self.errors = invalid.errors
  end
end
