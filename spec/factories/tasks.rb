FactoryGirl.define do
    factory :task do
        from ''
        to 'en'
        uid Digest::MD5.hexdigest(Time.current.to_s)
        status 'active'
    end

    factory :invalid_task, class: 'Task' do
        from ''
        to ''
        uid Digest::MD5.hexdigest(Time.current.to_s)
        status 'active'
    end
end
