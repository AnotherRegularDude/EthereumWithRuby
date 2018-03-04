module ContractDataSeedHelper
  def seed_isbn_contract(contract, repeat = 100)
    repeat.times do
      data = create(:book_edition, :full_info).attributes
      mutate_data!(data)

      id = contract.call.common_index_id

      contract.transact_and_wait.add_book(*data.values_at('title', 'isbn10', 'isbn13', 'edition', 'binding'))
      contract.transact_and_wait.set_book_additional_info(id, *data.values_at('author', 'publish_date', 'price', 'description'))
      contract.transact_and_wait.set_book_dimensions(id, *data.values_at('height', 'width', 'depth'))
    end
  end

  private

  def mutate_data!(data)
    data['publish_date'] = data['publish_date'].to_s
    data['edition'] = BookEdition.editions[data['edition']]
    data['binding'] = BookEdition.bindings[data['binding']]
  end
end
