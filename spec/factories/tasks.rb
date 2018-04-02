FactoryBot.define do
  factory :task do
    from ''
    to 'en'
    uid Digest::MD5.hexdigest(Time.current.to_s)
    status 'active'
    association :framework

    trait :done do
      status 'done'
    end

    trait :failed do
      status 'failed'
    end

    trait :with_yml do
      file File.open(File.join(Rails.root, 'spec/test_files/ru.yml'))
    end

    trait :with_long_yml do
      file File.open(File.join(Rails.root, 'spec/test_files/hard_with_params.en.yml'))
    end

    trait :with_strings do
      file File.open(File.join(Rails.root, 'spec/test_files/Main.strings'))
    end

    trait :with_resx do
      file File.open(File.join(Rails.root, 'spec/test_files/UIStrings.resx'))
    end

    trait :with_long_resx do
      file File.open(File.join(Rails.root, 'spec/test_files/UIStrings.en-GB.resx'))
    end

    trait :with_xml do
      file File.open(File.join(Rails.root, 'spec/test_files/strings.xml'))
    end

    trait :with_wrong_xml do
      file File.open(File.join(Rails.root, 'spec/test_files/strings.wrong.xml'))
    end

    trait :with_locale_xml do
      file File.open(File.join(Rails.root, 'spec/test_files/more_strings.ru.xml'))
    end

    trait :with_json do
      file File.open(File.join(Rails.root, 'spec/test_files/data.json'))
    end

    trait :with_json_keyed do
      file File.open(File.join(Rails.root, 'spec/test_files/de.json'))
    end

    trait :with_wrong_yml do
      file File.open(File.join(Rails.root, 'spec/test_files/wrong_ru.yml'))
    end

    trait :with_double_locale_yml do
      file File.open(File.join(Rails.root, 'spec/test_files/nb-NO.yml'))
    end

    trait :with_wrong_json do
      file File.open(File.join(Rails.root, 'spec/test_files/data_wrong.json'))
    end

    trait :with_php do
      file File.open(File.join(Rails.root, 'spec/test_files/app.php'))
    end
  end

  factory :invalid_task, class: 'Task' do
    from ''
    to ''
    uid Digest::MD5.hexdigest(Time.current.to_s)
    status 'active'
  end
end
