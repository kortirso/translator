en_word = Word.create text: 'Hello', locale: 'en'
ru_word = Word.create text: 'Привет', locale: 'ru'
Translation.create base: en_word, result: ru_word