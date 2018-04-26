class EthereumTools
  def self.parse_inputs(contract, input_name)
    input_abi = contract.abi.find { |info| info['name'] == input_name }
    return if input_abi.blank?

    inputs = input_abi['inputs'].map { |input| OpenStruct.new(input) }
    return if inputs.blank?

    inputs
  end

  def self.generate_filter_id(contract, event_function_name, options = {})
    from_block = options.fetch(:from_block, '0x0')
    to_block = options.fetch(:to_block, :latest)
    event_function_name = event_function_name.underscore

    contract.new_filter.send(event_function_name, from_block: from_block, to_block: to_block, topics: [])
  end

  def self.events_from_filter(contract, event_function_name, filter_id)
    contract.get_filter_logs.send(event_function_name.underscore, filter_id)
  end
end
