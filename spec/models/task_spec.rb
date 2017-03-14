RSpec.describe Task, type: :model do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :status }
    it { should validate_inclusion_of(:status).in_array(%w(active done)) }

    it 'should be valid' do
        task = create :task

        expect(task).to be_valid
    end
end
