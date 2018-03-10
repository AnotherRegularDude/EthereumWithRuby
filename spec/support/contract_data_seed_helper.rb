module ContractDataSeedHelper
  def seed_isbn_contract(contract, repeat = 20)
    repeat.times do
      data = create(:book_edition, :full_info).attributes
      mutate_data!(data)

      id = contract.call.index
      creation_data = data.values_at('title', 'isbn10', 'isbn13')

      contract.transact_and_wait.add_book(creation_data)
      contract.transact_and_wait.update_book_edition(id, *(data - creation_data).except('created_at', 'updated_at'))
    end
  end

  private

  def mutate_data!(data)
    data['publish_date'] = data['publish_date'].to_s
    data['edition'] = BookEdition.editions[data['edition']]
    data['binding'] = BookEdition.bindings[data['binding']]
  end
end
