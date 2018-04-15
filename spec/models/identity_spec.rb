RSpec.describe Identity, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :user }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }

  it 'should be valid' do
    identity = create :identity

    expect(identity).to be_valid
  end

  describe 'class methods' do
    context '.find_for_oauth' do
      let(:oauth) { create :oauth }

      context 'for unexisted identity' do
        it 'should return nil' do
          expect(Identity.find_for_oauth(oauth)).to eq nil
        end
      end

      context 'for existed identity' do
        let!(:identity) { create :identity, uid: oauth.uid }

        it 'should return identity object' do
          expect(Identity.find_for_oauth(oauth)).to eq identity
        end
      end
    end
  end
end
