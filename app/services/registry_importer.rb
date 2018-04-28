class RegistryImporter
  def initialize(contract, input_name, model, form, entity_contract_name)
    @contract = contract
    @input_name = input_name
    @inputs = EthereumTools.parse_inputs(@contract, @input_name)

    @model = model
    @form = form
    @entity_contract_name = entity_contract_name
  end

  def call
    blocks_result = SafeBlockManager.call(@contract)
    return if blocks_result.blank?

    filter_id = EthereumTools.generate_filter_id(
      @contract,
      @input_name,
      from_block: blocks_result[:from_block],
      to_block: blocks_result[:last_block],
    )
    events = EthereumTools.events_from_filter(@contract, @input_name, filter_id)

    @model.connection.transaction do
      events.each do |event|
        transaction_id = event[:transactionHash]
        transaction = Ethereum::Singleton.instance.eth_get_transaction_receipt(transaction_id)
        args = EthereumTools.decode_arguments(transaction, @inputs)

        entity_id = args.first.to_i
        mapped_item = ContractDataMapper.call(@contract, @entity_contract_name, entity_id)
        next if mapped_item.blank?

        puts mapped_item.merge!(external_contract_id: entity_id)
      end
    end
  end
end
