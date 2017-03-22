RSpec.describe Task, type: :model do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :status }
    it { should validate_presence_of :to }
    it { should validate_inclusion_of(:status).in_array(%w(active done)) }
    it { should validate_length_of(:from).is_equal_to(2) }
    it { should allow_value('').for(:from) }
    it { should validate_length_of(:to).is_equal_to(2) }

    it 'should be valid' do
        task = create :task

        expect(task).to be_valid
    end

    describe 'methods' do
        context '.task_processing' do
            subject { build :task }

            it 'should perform_later job TaskProcessingJob' do
                skip
                expect(TaskProcessingJob).to receive(:perform_later).with(subject)
                subject.save!
            end
        end
    end
end
