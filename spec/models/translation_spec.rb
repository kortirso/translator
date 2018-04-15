RSpec.describe Translation, type: :model do
  it { should belong_to(:base).class_name('Word') }
  it { should belong_to(:result).class_name('Word') }
  it { should validate_presence_of :base }
  it { should validate_presence_of :result }

  it 'should be valid' do
    translation = create :translation

    expect(translation).to be_valid
  end

  describe 'methods' do
    context '.translation' do
      let!(:object) { create :translation }

      it 'returns result word if identifier is eq base' do
        expect(object.translation(object.base_id)).to eq object.result
      end

      it 'returns base word if identifier is eq result' do
        expect(object.translation(object.result_id)).to eq object.base
      end
    end
  end
end
