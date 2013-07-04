FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :category do
    sequence(:name) { |n| "category #{n}" }
    description "some description"
    user
  end

  factory :item do
    barcode_custom "barcode"
    category
  end
end