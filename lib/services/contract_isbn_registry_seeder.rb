class ContractIsbnRegistrySeeder < ApplicationService
  def initialize(contract:, entity_count:)
    @contract = contract
    @entity_count = entity_count&.abs || 20
  end

  def call
    @entity_count.times do
      @book_data = FactoryBot.build(:book_edition, :full_info).attributes.deep_symbolize_keys
      mutate_data!

      @id = @contract.call.index
      add_book_edition
      update_full_info
    end
  end

  private

  def mutate_data!
    @book_data[:publish_date] = @book_data[:publish_date].to_s
    @book_data[:edition] = BookEdition.editions[@book_data[:edition]]
    @book_data[:binding] = BookEdition.bindings[@book_data[:binding]]
  end

  def add_book_edition
    creatiion_data = @book_data.values_at(:title, :isbn10, :isbn13)

    @contract.transact_and_wait.add_book_edition(*creatiion_data)
  end

  def update_full_info
    update_data = @book_data.values_at(:author, :publish_date, :edition, :binding, :price, :width, :height, :depth, :description).prepend(@id)

    @contract.transact_and_wait.update_book_edition(*update_data)
  end
end
