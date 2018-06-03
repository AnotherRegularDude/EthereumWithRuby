class ApplicationForm
  include Virtus.model
  include ActiveModel::Model

  def persisted?
    false
  end

  def save
    return false unless valid?

    persist!
  end
end
