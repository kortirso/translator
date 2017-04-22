RSpec.describe Word, type: :model do
    it { should belong_to :locale }
    it { should have_many(:translations).with_foreign_key(:base_id).dependent(:destroy) }
    it { should have_many(:result_words).through(:translations).source(:result) }
    it { should have_many(:reverse_translations).with_foreign_key(:result_id).class_name('Translation').dependent(:destroy) }
    it { should have_many(:base_words).through(:reverse_translations).source(:base) }
    it { should validate_presence_of :text }
    it { should validate_presence_of :locale_id }

    it 'should be valid' do
        word = create :word

        expect(word).to be_valid
    end
end
