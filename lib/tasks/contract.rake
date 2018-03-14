namespace :contract do
  desc 'Deploy new contract, get info from settings'
  task :deploy, [:name] => :environment do |_, args|
    contract_info = Rails.configuration.x.contracts[args[:name]]
    if contract_info.present?
      contract = ContractCreator.call(path_to_contract: contract_info.file_path)
      messages = {
        address: I18n.t('contracts_rake.address_info', address: contract.address),
        file_path: I18n.t('contracts_rake.path_info', file_path: contract_info.file_path)
      }

      puts messages[:address]
      Rails.logger.info(messages[:address])
      Rails.logger.info(messages[:file_path])
    else
      Rails.logger.error(I18n.t('contracts_rake.errors.no_info'))
    end
  end

  desc 'Seed IsbnRegistry contract with entities (only in development)'
  task :seed_isbn_registry, [:number_of_tries] => :environment do |_, args|
    unless Rails.env.production?
      contract = AppContractHolder.instance.isbn_contract
      number_of_tries = args[:number_of_tries]
      id_before = contract.call.index
      ContractIsbnRegistrySeeder.call(contract: contract, entity_count: number_of_tries)

      Rails.logger.info("Created #{contract.call.index - id_before} entities in IsbnRegistry.")
    end
  end

  namespace :import do
    desc 'Import IsbnRegistry data to database'
    task isbn_registry: :environment do
      contract = AppContractHolder.instance.isbn_contract
      Rails.logger.info(I18n.t('contracts_rake.start_import'))

      RegistryImporter.call(
        contract: contract,
        mapper_name: 'bookEditions',
        import_model: BookEdition,
        creation_form: CreateBookEditionForm
      )

      Rails.logger.info(I18n.t('contracts_rake.imported'))
    end
  end
end
