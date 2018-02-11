class ContractCreationService
  class << self
    def create_and_wait(file_path:, contract_args: [])
      contract = Ethereum::Contract.create(file: file_path)
      contract_args = Array.wrap(contract_args)
      contract.deploy_and_wait(*contract_args)

      contract
    end

    def from_address(file_path:, address:)
      Ethereum::Contract.create(file: file_path, address: address)
    end

    def from_abi(name: nil, address:, abi:)
      name ||= 'DefaultContractName'
      Ethereum::Contract.create(name: name, address: address, abi: abi)
    end
  end
end
