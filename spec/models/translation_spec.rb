RSpec.describe Translation, type: :model do
    it { should belong_to(:base).class_name('Word') }
    it { should belong_to(:result).class_name('Word') }
    it { should have_many(:positions).dependent(:destroy) }
    it { should validate_presence_of :base_id }
    it { should validate_presence_of :result_id }

    it 'should be valid' do
        translation = create :translation

        expect(translation).to be_valid
    end
end
