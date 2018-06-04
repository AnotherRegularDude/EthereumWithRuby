class SessionForm < ApplicationForm
  define_model :user

  attribute :username, String
  attribute :password, String

  def username=(value)
    @username = value.downcase
  end

  private

  def persist!
    @model = User.find_by(username: username)&.authenticate(password)
    return true if persisted?

    errors.add(:username)
    errors.add(:password)
    false
  end
end
