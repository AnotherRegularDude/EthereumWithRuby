class ContractDataMapper
  def self.call(contract, mapper_name, id)
    abi = contract.abi.find { |abi_info| abi_info['name'] == mapper_name }
    return if abi.blank?

    keys = abi['outputs'].map { |output| output['name'].underscore.to_sym }
    return if keys.blank?

    keys.zip(contract.call.send(mapper_name.underscore, id)).to_h
  end
end
