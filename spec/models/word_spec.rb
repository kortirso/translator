RSpec.describe Word, type: :model do
    it { should belong_to :locale }
    it { should have_many(:translations).with_foreign_key(:base_id).dependent(:destroy) }
    it { should have_many(:result_words).through(:translations).source(:result) }
    it { should have_many(:reverse_translations).with_foreign_key(:result_id).class_name('Translation').dependent(:destroy) }
    it { should have_many(:base_words).through(:reverse_translations).source(:base) }
    it { should validate_presence_of :text }
    it { should validate_presence_of :locale_id }

    it 'should be valid' do
        word = create :word, :en

        expect(word).to be_valid
    end

    describe 'methods' do
        context '.select_translations' do
            let!(:word_1) { create :word, :en }
            let!(:word_2) { create :word, :ru }
            let!(:translation) { create :translation, base: word_1, result: word_2 }

            it 'should return word_2 as translation for word_1' do
                expect(word_1.select_translations('ru')).to eq [word_2]
            end

            it 'should return word_1 as translation for word_2' do
                expect(word_2.select_translations('en')).to eq [word_1]
            end
        end
    end
end
