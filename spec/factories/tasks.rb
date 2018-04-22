FactoryBot.define do
  factory :task do
    from ''
    to 'en'
    uid Digest::MD5.hexdigest(Time.current.to_s)
    status 'active'
    association :framework
    association :personable, factory: :user

    trait :done do
      status 'done'
    end

    trait :failed do
      status 'failed'
    end

    trait :with_yml do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/ru.yml"))
      end
    end

    trait :with_long_yml do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/hard_with_params.en.yml"))
      end
    end

    trait :with_strings do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/Main.strings"))
      end
    end

    trait :with_locale_strings do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/Main.ru.strings"))
      end
    end

    trait :with_wrong_strings do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/Main.rur.strings"))
      end
    end

    trait :with_resx do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/UIStrings.resx"))
      end
    end

    trait :with_long_resx do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/UIStrings.en-GB.resx"))
      end
    end

    trait :with_xml do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/strings.xml"))
      end
    end

    trait :with_wrong_xml do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/strings.wrong.xml"))
      end
    end

    trait :with_locale_xml do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/more_strings.ru.xml"))
      end
    end

    trait :with_json do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/data.json"))
      end
    end

    trait :with_json_keyed do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/de.json"))
      end
    end

    trait :with_wrong_json_keyed do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/ded.json"))
      end
    end

    trait :with_wrong_yml do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/wrong_ru.yml"))
      end
    end

    trait :with_double_locale_yml do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/nb-NO.yml"))
      end
    end

    trait :with_wrong_json do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/data_wrong.json"))
      end
    end

    trait :with_php do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/app.php"))
      end
    end

    trait :with_locale_php do
      after(:create) do |task|
        task.file.attach(Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/app.ru.php"))
      end
    end
  end

  factory :invalid_task, class: 'Task' do
    from ''
    to ''
    uid Digest::MD5.hexdigest(Time.current.to_s)
    status 'active'
  end
end
