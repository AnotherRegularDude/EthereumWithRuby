class ContractDataMapper < ApplicationService
  def initialize(contract:, constant_name:, id:)
    @contract = contract
    @constant_name = constant_name
    @id = id
  end

  def call
    abi = @contract.abi.find { |abi_info| abi_info['name'] == @constant_name }
    return if abi.blank?

    keys = abi['outputs'].map { |output| output['name'].underscore.to_sym }
    return if keys.blank?

    keys.zip(@contract.call.send(@constant_name.underscore, @id)).to_h
  end
end
