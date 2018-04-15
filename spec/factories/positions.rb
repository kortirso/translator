FactoryBot.define do
  factory :position do
    base_value 'Some text'
    temp_value '_##phrase_1##_'
    association :task
  end
end
