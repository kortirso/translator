RSpec.describe Identity, type: :model do
    it { should belong_to :user }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :provider }

    it 'should be valid' do
        identity = create :identity

        expect(identity).to be_valid
    end

    describe 'methods' do
        context '.find_for_oauth' do
        end
    end
end
