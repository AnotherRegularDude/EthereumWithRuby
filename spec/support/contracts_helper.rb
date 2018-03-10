module ContractsHelper
  def create_isbn_registry_contract
    ContractCreator.call(path_to_contract: Rails.root.join('lib', 'solidity_scripts', 'isbn_registry.sol'))
  end

  def seed_isbn_registry(contract)
    ContractIsbnRegistrySeeder.call(contract: contract, entity_count: 3)
  end
end
