class RegistryImporter < ApplicationService
  def initialize(contract:, mapper_name:, import_model:, creation_form:)
    @contract = contract
    @mapper_name = mapper_name

    @import_model = import_model
    @creation_form = creation_form
  end

  def call
    start_id = (@import_model.maximum('external_contract_id') || -1) + 1
    end_id = @contract.call.index

    @import_model.connection.transaction do
      (start_id...end_id).each do |id|
        data = ContractDataMapper.call(contract: @contract, mapper_name: @mapper_name, id: id)
        form = @creation_form.new(data.merge(external_contract_id: id))

        form.save
      end
    end
  end
end
