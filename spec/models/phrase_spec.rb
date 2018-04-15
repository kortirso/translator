RSpec.describe Phrase, type: :model do
  it { should belong_to :position }
  it { should belong_to :word }
  it { should validate_presence_of :position }
  it { should validate_presence_of :word }

  it 'should be valid' do
    phrase = create :phrase

    expect(phrase).to be_valid
  end
end
