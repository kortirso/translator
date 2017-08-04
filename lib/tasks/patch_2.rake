namespace :patching do
    desc 'Update locales'
    task patch_2: :environment do
        Locale.create code: 'fr', country_code: 'FR', names: { en: 'French', ru: 'Французский', da: 'Fransk', fr: 'Français', de: 'Französisch', es: 'Francés', pt: 'Francês' }
        Locale.create code: 'de', country_code: 'DE', names: { en: 'German', ru: 'Немецкий', da: 'Tysk', fr: 'Allemand', de: 'Deutsch', es: 'Alemán', pt: 'Alemão' }
        Locale.create code: 'es', country_code: 'ES', names: { en: 'Spanish', ru: 'Испанский', da: 'Spansk', fr: 'Espagnol', de: 'Spanisch', es: 'Español', pt: 'Espanhol' }
        Locale.create code: 'pt', country_code: 'PT', names: { en: 'Portuguese', ru: 'Португальский', da: 'Portugisisk', fr: 'Portugais', de: 'Portugiesisch', es: 'Portugués', pt: 'Português' }

        Locale.find_by(code: 'en').update(names: { en: 'English', ru: 'Английский', da: 'Engelsk', fr: 'Anglais', de: 'Englisch', es: 'Inglés', pt: 'Inglês' })
        Locale.find_by(code: 'ru').update(names: { en: 'Russian', ru: 'Русский', da: 'Russisk', fr: 'Russe', de: 'Russisch', es: 'Ruso', pt: 'Russo' })
        Locale.find_by(code: 'da').update(names: { en: 'Danish', ru: 'Датский', da: 'Dansk', fr: 'Danois', de: 'Dänisch', es: 'Danés', pt: 'Dinamarquês' })
    end
end