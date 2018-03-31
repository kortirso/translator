namespace :patching do
  desc 'Create frameworks'
  task patch_3: :environment do
    Framework.create(name: 'Ruby on Rails', extension: 'yml')
    Framework.create(name: 'ReactJS', extension: 'json')
    Framework.create(name: 'Laravel', extension: 'json')
    Framework.create(name: '.NET', extension: 'resx')
    Framework.create(name: 'iOS', extension: 'strings')
    Framework.create(name: 'Android', extension: 'xml')
    Framework.create(name: 'Yii', extension: 'php')
  end
end