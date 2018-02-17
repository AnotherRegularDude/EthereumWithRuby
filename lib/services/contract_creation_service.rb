# TODO: changes service interface
class ContractCreationService
  class << self
    def from_address(file_path:, address:)
      Ethereum::Contract.create(file: file_path, address: address)
    end

    def from_abi(name: nil, address:, abi:)
      name ||= 'DefaultContractName'
      Ethereum::Contract.create(name: name, address: address, abi: abi)
    end
  end
end
