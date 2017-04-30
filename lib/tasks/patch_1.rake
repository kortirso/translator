namespace :patching do
    desc 'Loading cards for collection Journey To Ungoro'
    task patch_1: :environment do
        Locale.find_by(code: 'en').update(names: {en: 'English', ru: 'Английский', da: 'Engelsk'})
        Locale.find_by(code: 'ru').update(names: {en: 'Russian', ru: 'Русский', da: 'Russisk'})
        Locale.find_by(code: 'da').update(names: {en: 'Danish', ru: 'Датский', da: 'Dansk'})
    end
end