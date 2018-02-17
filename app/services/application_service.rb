# Base service class, which hold general logic.
class ApplicationService
  def self.call(**kwargs)
    return new.call if kwargs.blank?

    new(kwargs).call
  end
end
