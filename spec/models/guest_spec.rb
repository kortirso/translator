RSpec.describe Guest, type: :model do
  it { should belong_to :user }
  it { should have_many(:tasks).dependent(:destroy) }

  it 'should be valid' do
    guest = create :guest

    expect(guest).to be_valid
  end
end
