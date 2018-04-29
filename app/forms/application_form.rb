class ApplicationForm
  include Virtus.model
  include ActiveModel::Model

  def persisted?
    false
  end
end
