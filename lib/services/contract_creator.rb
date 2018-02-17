class ContractCreator < ApplicationService
  def initialize(path_to_cotract:, args_for_contract:)
    @path_to_cotract = path_to_cotract
    @args_for_contract = args_for_contract
  end

  def call
    contract = Ethereum::Contract.create(file: @file_path)
    contract.deploy_and_wait(*Array.wrap(@args_for_contract))

    contract
  end
end
