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

      Rails.logger.info(messages[:address])
      Rails.logger.info(messages[:file_path])
    else
      Rails.logger.error(I18n.t('contracts_rake.errors.no_info'))
    end
  end

  desc 'Deploy all specified if project contracts'
  task deploy_all: :environment do
    contracts = Rails.configuration.x.contracts
    contracts.each_value do |contract_info|
      contract = ContractCreator.call(path_to_contract: contract_info.file_path)
      messages = {
        address: I18n.t('contracts_rake.address_info', address: contract.address),
        file_path: I18n.t('contracts_rake.path_info', file_path: contract_info.file_path)
      }

      Rails.logger.info(messages[:address])
      Rails.logger.info(messages[:file_path])
    end
  end
end
