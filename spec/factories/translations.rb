FactoryBot.define do
  factory :translation do
    verified false
    association :base, factory: %i[word ru]
    association :result, factory: %i[word en]
  end
end
