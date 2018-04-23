class AppContractHolder
  include Singleton

  attr_reader :isbn_contract

  def initialize
    isbn_config = Rails.configuration.x.contracts.isbn_registry

    @isbn_contract = Ethereum::Contract.create(file: isbn_config.file_path, address: isbn_config.address)
  end
end
