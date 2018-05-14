RSpec.describe Position, type: :model do
  it { should belong_to :task }
  it { should have_many(:phrases).dependent(:destroy) }
  it { should validate_presence_of :task }
  it { should validate_presence_of :base_value }

  it 'should be valid' do
    position = create :position

    expect(position).to be_valid
  end
end
