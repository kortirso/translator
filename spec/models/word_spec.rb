RSpec.describe Word, type: :model do
  it { should belong_to :locale }
  it { should have_many :phrases }
  it { should validate_presence_of :text }
  it { should validate_presence_of :locale }

  it 'should be valid' do
    word = create :word, :en

    expect(word).to be_valid
  end

  describe 'class methods' do
    context '.create_or_find_by' do
      let!(:locale_en) { create :locale, :en }
      let(:request) { Word.create_or_find_by(text: 'Hello', locale: locale_en) }

      context 'if word does not exist' do
        it 'creates new word' do
          expect { request }.to change(Word, :count).by(1)
        end

        it 'and returns it' do
          expect(request.is_a?(Word)).to eq true
        end
      end

      context 'if word exists' do
        let!(:word) { create :word, text: 'Hello', locale: locale_en }

        it 'does not create new word' do
          expect { request }.to_not change(Word, :count)
        end

        it 'and returns already existed' do
          expect(request).to eq word
        end
      end
    end
  end

  describe 'methods' do
    let!(:word_1) { create :word, :en }
    let!(:word_2) { create :word, :ru }
    let!(:word_3) { create :word, :es }
    let!(:translation_1) { create :translation, base: word_1, result: word_2 }
    let!(:translation_2) { create :translation, base: word_2, result: word_3 }
    let(:locale_en) { Locale.find_by(code: 'en') }

    context '.select_translations' do
      it 'returns hash with word_1 for en locale' do
        expect(word_2.select_translations(locale: locale_en)).to eq(word_1.text => 1)
      end

      it 'returns hash with all words' do
        expect(word_2.select_translations).to eq(word_1.text => 1, word_3.text => 1)
      end
    end

    context '.translated_text' do
      it 'returns texts for en locale' do
        expect(word_2.translated_text(locale: locale_en)).to eq [word_1.text]
      end

      it 'returns texts for all locales' do
        expect(word_2.translated_text).to eq [word_1.text, word_3.text]
      end
    end

    context '.grouped_translated_text' do
      context 'with locale' do
        it 'returns hash with translated text as keys and array of WORD objects as values' do
          result = word_2.send(:grouped_translated_text, locale_en)

          expect(result).to eq(word_1.text => [word_1])
        end
      end

      context 'without locale' do
        it 'returns hash with translated text as keys and array of WORD objects as values' do
          result = word_2.send(:grouped_translated_text, nil)

          expect(result).to eq(word_1.text => [word_1], word_3.text => [word_3])
        end
      end
    end

    context '.for_language' do
      it 'returns all WORD objects for word through translations for locale' do
        result = word_2.send(:for_language, locale_en)

        expect(result.size).to eq 1
        expect(result[0].is_a?(Word)).to eq true
        expect(result[0]).to eq word_1
      end
    end

    context '.translations' do
      it 'returns all WORD objects for word through translations' do
        result = word_2.send(:translations)

        expect(result.size).to eq 2
        result.each do |res|
          expect(res.is_a?(Word)).to eq true
          expect(res == word_1 || res == word_3).to eq true
        end
      end
    end

    context '.interpretations' do
      it 'returns all TRANSLATION objects for word' do
        result = word_2.send(:interpretations)

        expect(result.size).to eq 2
        result.each do |res|
          expect(res.is_a?(Translation)).to eq true
        end
      end
    end
  end
end
