FactoryBot.define do
  factory :book_edition do
    title { Faker::Book.title }
    isbn10 { Faker::Number.unique.number(10) }
    isbn13 { Faker::Number.unique.number(13) }
    edition { Faker::Number.between(0, 7) }
    binding { Faker::Number.between(0, 4) }
    deleted false

    trait :full_info do
      author { Faker::Book.author }
      description { Faker::Lorem.paragraph }
      publish_date { Faker::Date.between(50.years.ago, Time.zone.today) }
      price { Faker::Number.between(100, 1000) }

      width { Faker::Number.between(50, 100) }
      height { Faker::Number.between(50, 100) }
      depth { Faker::Number.between(50, 100) }
    end

    trait :deleted do
      deleted true
    end

    factory :full_deleted_book_edition, traits: %i[full_info deleted]
  end
end
