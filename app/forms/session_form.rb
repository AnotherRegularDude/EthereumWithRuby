class SessionForm < ApplicationForm
  attr_reader :user

  attribute :username, String
  attribute :password, String

  def username=(value)
    @username = value.downcase
  end

  private

  def persist!
    @user = User.find_by(username: username)&.authenticate(password)
    return true if @user.present?

    errors.add(:username)
    errors.add(:password)
    false
  end
end
