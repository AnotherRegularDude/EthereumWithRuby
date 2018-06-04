class UserForm < ApplicationForm
  define_model :user

  attribute :username, String
  attribute :password, String
  attribute :role, Integer

  validates :username, :password, presence: true, unless: :persisted?
  validates :role, inclusion: { in: 0..2 }, allow_blank: true
  validates :username, :password, length: { in: 4..20 }, allow_blank: true

  def username=(value)
    @username = value.downcase
  end

  private

  def persist!
    model.attributes = attributes.compact
    model.save!

    true
  rescue ActiveRecord::RecordInvalid => invalid
    @errors = invalid.record.errors

    false
  end
end
