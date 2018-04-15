FactoryBot.define do
  factory :phrase do
    current_value 'Some translation'
    association :position
    association :word, :en
  end
end
