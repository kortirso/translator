FactoryBot.define do
  factory :framework do
    name 'Ruby on Rails'
    extension 'yml'
    service 'RailsService'
  end

  factory :rails_framework, class: 'Framework' do
    name 'Ruby on Rails'
    extension 'yml'
    service 'RailsService'
  end

  factory :android_framework, class: 'Framework' do
    name 'Android'
    extension 'xml'
    service 'AndroidService'
  end

  factory :ios_framework, class: 'Framework' do
    name 'Ios'
    extension 'strings'
    service 'IosService'
  end

  factory :laravel_framework, class: 'Framework' do
    name 'Laravel'
    extension 'json'
    service 'LaravelService'
  end

  factory :net_framework, class: 'Framework' do
    name 'Net'
    extension 'resx'
    service 'NetService'
  end
end
