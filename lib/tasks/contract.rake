namespace :contract do
  desc 'Deploy new contract, get info from settings'
  task :deploy, [:name] => :environment do |_, args|
    contract_info = Rails.configuration.x.contracts[args[:name]]
    puts 'No information about contract' if contract_info.blank?
    contract = ContractCreator.call(path_to_contract: contract_info.file_path)

    puts "Contract address: #{contract.address}"
    puts "Contract path: #{contract_info.file_path}"
  end

  desc 'Seed IsbnRegistry contract with entities (only in development)'
  task :seed_isbn_registry, [:number_of_tries] => :environment do |_, args|
    contract = AppContractHolder.instance.isbn_contract
    number_of_tries = args[:number_of_tries]
    id_before = contract.call.index
    ContractIsbnRegistrySeeder.call(contract: contract, entity_count: number_of_tries)

    puts "Created #{contract.call.index - id_before} entities in IsbnRegistry."
  end

  namespace :import do
    desc 'Import IsbnRegistry data to database'
    task isbn_registry: :environment do
      contract = AppContractHolder.instance.isbn_contract
      puts 'Start importing (may take some time)'

      RegistryImporter.call(
        contract: contract,
        mapper_name: 'bookEditions',
        import_model: BookEdition,
        creation_form: CreateBookEditionForm
      )

      puts 'Imported'
    end
  end
end
