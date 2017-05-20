RSpec.describe Word, type: :model do
    it { should belong_to :locale }
    it { should have_many(:translations).with_foreign_key(:base_id).dependent(:destroy) }
    it { should have_many(:result_words).through(:translations).source(:result) }
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
            let!(:translation_1) { create :translation, base: word_1, result: word_2, direction: "#{word_1.locale.code}-#{word_2.locale.code}" }
            let!(:translation_2) { create :translation, base: word_2, result: word_1, direction: "#{word_2.locale.code}-#{word_1.locale.code}" }

            it 'should return word_2 as translation for word_1 with amount eq 1' do
                expect(word_1.select_translations(word_2.locale)).to eq({word_2.text => 1})
            end

            it 'should return word_1 as translation for word_2 with amount eq 1' do
                expect(word_2.select_translations(word_1.locale)).to eq({word_1.text => 1})
            end
        end
    end
end
