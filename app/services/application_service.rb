# Base service class, which hold general logic.
class ApplicationService
  def self.call(*args)
    return new.call if args.blank?

    new(*args).call
  end
end
