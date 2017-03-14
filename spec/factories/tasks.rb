FactoryGirl.define do
    factory :task do
        uid Digest::MD5.hexdigest(Time.current.to_s)
        status 'active'
    end
end
