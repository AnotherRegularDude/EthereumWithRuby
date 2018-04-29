class ContractCreator < ApplicationService
  def initialize(path_to_contract, options = {})
    @path_to_contract = path_to_contract
    @args_for_contract = options[:args_for_contract]
  end

  def call
    contract = Ethereum::Contract.create(file: @path_to_contract)
    contract.deploy_and_wait(*Array.wrap(@args_for_contract))

    contract
  end
end
