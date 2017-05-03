RSpec.describe Locale, type: :model do
    it { should have_many(:words).dependent(:destroy) }
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of :code }
    it { should validate_presence_of :country_code }
    it { should validate_uniqueness_of :country_code }

    it 'should be valid' do
        locale = create :locale, :en

        expect(locale).to be_valid
    end
end
