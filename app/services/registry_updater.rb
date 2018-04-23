class RegistryUpdater < ApplicationService
  def initialize(name_of_event:, import_model:)
    @name_of_event = name_of_event
    @import_model = import_model
  end
end
