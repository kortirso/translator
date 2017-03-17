FactoryGirl.define do
    factory :task do
        from ''
        to 'en'
        uid Digest::MD5.hexdigest(Time.current.to_s)
        status 'active'
        file File.open(File.join(Rails.root, 'config/locales/en.yml'))
    end

    factory :invalid_task, class: 'Task' do
        from ''
        to ''
        uid Digest::MD5.hexdigest(Time.current.to_s)
        status 'active'
        file File.open(File.join(Rails.root, 'config/locales/en.yml'))
    end
end
