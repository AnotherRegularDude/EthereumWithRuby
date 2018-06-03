class UserForm < ApplicationForm
  attr_writer :user

  attribute :username, String
  attribute :password, String
  attribute :role, Integer

  validates :username, :password, presence: true, unless: proc { |form| form.user.persisted? }
  validates :role, inclusion: { in: 0..2 }, allow_blank: true
  validates :username, :password, length: { in: 4..20 }, allow_blank: true

  def user
    @user ||= User.new
  end

  def username=(value)
    @username = value.downcase
  end

  private

  def persist!
    user.attributes = attributes.compact
    user.save!

    true
  rescue ActiveRecord::RecordInvalid => invalid
    @errors = invalid.record.errors

    false
  end
end
