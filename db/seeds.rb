locale_en = Locale.create code: 'en', country_code: 'EN', names: {en: 'English', ru: 'Англиский'}
locale_ru = Locale.create code: 'ru', country_code: 'RU', names: {en: 'Russian', ru: 'Русский'}

en_word = Word.create text: 'Hello', locale: locale_en
ru_word = Word.create text: 'Привет', locale: locale_ru
Translation.create base: en_word, result: ru_word