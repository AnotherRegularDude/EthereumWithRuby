class RegistryImporter < ApplicationService
  def initialize(contract:, mapper_name:, import_model:, creation_form:)
    @contract = contract
    @mapper_name = mapper_name

    @import_model = import_model
    @creation_form = creation_form
  end

  def call
    init_redis_store
    write_contract_cache

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

  private

  def process_redis_cache
    conf = Rails.configuration.x.redis
    block_number = Ethereum::Singleton.instance.eth_block_number['result'].to_i(16)

    redis = ActiveSupport::Cache.lookup_store :redis_store, conf.connection_string, conf.namespace
    redis.write(:last_watched_block, block_number)
  end
end
