RSpec.describe Framework, type: :model do
    it { should have_many :tasks }
    it { should validate_presence_of :name }
    it { should validate_presence_of :extension }

    it 'should be valid' do
        framework = create :framework

        expect(framework).to be_valid
    end
end
