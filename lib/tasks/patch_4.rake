namespace :patching do
    desc 'Add services to frameworks'
    task patch_4: :environment do
        Framework.find_by(name: 'Ruby on Rails', extension: 'yml').update(service: 'RailsService')
        Framework.find_by(name: 'ReactJS', extension: 'json').update(service: 'ReactService')
        Framework.find_by(name: 'Laravel', extension: 'json').update(service: 'LaravelService')
        Framework.find_by(name: '.NET', extension: 'resx').update(service: 'NetService')
        Framework.find_by(name: 'iOS', extension: 'strings').update(service: 'IosService')
        Framework.find_by(name: 'Android', extension: 'xml').update(service: 'AndroidService')
        Framework.find_by(name: 'Yii', extension: 'php').update(service: 'YiiService')
    end
end