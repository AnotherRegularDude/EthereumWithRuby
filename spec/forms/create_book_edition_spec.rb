require 'spec_helper'

describe CreateBookEdition do
  subject { CreateBookEdition }

  let(:new_form) { subject.new(data) }
  let(:saved_form) do
    new_form.save

    new_form
  end

  context 'with minimum of correct data' do
    let(:data) { build(:book_edition).attributes.slice('title', 'isbn10', 'isbn13', 'deleted') }

    it { expect(new_form.save).to be true }
    it { expect(saved_form.book_edition).to be_an_instance_of(BookEdition) }
    it { expect(saved_form.book_edition.id).not_to be nil }
  end

  context 'with full correct data' do
    let(:data) { build(:book_edition, :full_info).attributes.except('id', 'created_at', 'updated_at') }

    it { expect(new_form.save).to be true }
    it { expect(saved_form.book_edition).to be_an_instance_of(BookEdition) }
    it { expect(saved_form.book_edition.id).not_to be nil }
  end

  context 'with incorrect data' do
    let(:data) { { title: Faker::Book.title, isbn13: Faker::Number.number(10) } }

    it { expect(new_form.save).to be false }
    it { expect(saved_form.errors.keys).to include(:isbn13) }
  end
end
