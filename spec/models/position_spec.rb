RSpec.describe Position, type: :model do
  it { should belong_to :task }
  it { should validate_presence_of :task_id }

  it 'should be valid' do
    position = create :position

    expect(position).to be_valid
  end
end
