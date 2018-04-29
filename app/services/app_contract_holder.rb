class AppContractHolder
  include Singleton

  attr_reader :isbn_registry, :book_instance_registry

  def initialize
    configs = Rails.configuration.x.contracts

    @isbn_registry = Ethereum::Contract.create(
      file: configs.isbn_registry.file_path,
      address: configs.isbn_registry.address
    )

    @book_instance_registry = Ethereum::Contract.create(
      file: configs.book_instance_registry.file_path,
      address: configs.book_instance_registry.address
    )
  end
end
