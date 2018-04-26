class CreateBookEditionForm < ApplicationForm
  attr_reader :book_edition

  attribute :title, String
  attribute :isbn10, String
  attribute :isbn13, String
  attribute :external_contract_id, Integer
  attribute :edition, Integer
  attribute :binding, Integer
  attribute :removed, Boolean

  attribute :author, String
  attribute :description, String
  attribute :publish_date, Date
  attribute :price, Integer

  attribute :height, Integer
  attribute :width, Integer
  attribute :depth, Integer

  validates :title, :isbn10, :isbn13, :external_contract_id, presence: true
  validates :removed, inclusion: { in: [true, false] }
  validates :isbn10, length: { is: 10 }
  validates :isbn13, length: { is: 13 }
  validates :height, :width, :depth,  numericality: { greater_than_or_equal: 0 }, allow_nil: true
end
