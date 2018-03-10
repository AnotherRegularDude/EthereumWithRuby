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
    desc 'Import all IsbnRegistry data to database'
    task all_isbn_registry: :environment do
      if BookEdition.maximum(:contract_link).zero?
        contract = AppContractHolder.instance.isbn_contract
        BookEdition.connection.transaction do
          contract.call.index.times do |id|
            data = ContractDataMapper.call(contract: contract, constant_name: 'bookEditions', id: id)
            form = CreateBookEditionForm.new(data.merge(contract_link: id))

            form.save
          end
        end
      else
        puts 'Database not empty, import already runned...'
      end
    end
  end
end
