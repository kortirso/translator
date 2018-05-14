RSpec.describe Position, type: :model do
  it { should belong_to :task }
  it { should have_many(:phrases).dependent(:destroy) }
  it { should validate_presence_of :task }
  it { should validate_presence_of :base_value }

  it 'should be valid' do
    position = create :position

    expect(position).to be_valid
  end

  describe 'methods' do
    context '.update_phrases_value' do
      let!(:position) { create :position }
      let!(:word) { create :word, :en }
      let!(:phrase_1) { create :phrase, position: position, current_value: '1', word: word }
      let!(:phrase_2) { create :phrase, position: position, current_value: '2', word: word }
      before { position.update(temp_value: "_###{phrase_1.id}##__###{phrase_2.id}##_") }

      it 'updates phrases_value of position with values from phrases' do
        expect { position.update_phrases_value }.to change(position, :phrases_value)
      end

      it 'does not update temp_value of position' do
        expect { position.update_phrases_value }.to_not change(position, :temp_value)
      end
    end
  end
end
