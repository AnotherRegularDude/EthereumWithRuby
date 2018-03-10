namespace :contract do
  desc 'Deploy new contract, get info from settings'
  task :deploy, [:name] => :environment do |t, args|
    contract_info = Rails.configuration.x.contracts[args[:name]]
    puts 'No information about contract' if contract_info.blank?
    contract = ContractCreator.call(path_to_contract: contract_info.file_path)

    puts "Contract address: #{contract.address}"
    puts "Contract path: #{contract_info.file_path}"
  end

  desc 'Seed IsbnRegistry contract with entities'
  task :seed_isbn_registry, [:number_of_tries] => :environment do |t, args|
    contract = AppContractHolder.instance.isbn_contract
    number_of_tries = args[:number_of_tries]
    id_before = contract.call.index
    ContractIsbnRegistrySeeder.call(contract: contract, entity_count: number_of_tries)

    puts "Created #{contract.call.index - id_before} entities in IsbnRegistry."
  end
end
