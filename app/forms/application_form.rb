class ApplicationForm
  include Virtus.model

  include ActiveModel::Model

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      return true
    end

    false
  end
end
