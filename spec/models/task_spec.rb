RSpec.describe Task, type: :model do
    it { should belong_to :user }
    it { should have_many(:positions).dependent(:destroy) }
    it { should have_many(:translations).through(:positions) }
    it { should validate_presence_of :uid }
    it { should validate_presence_of :status }
    it { should validate_presence_of :to }
    it { should validate_inclusion_of(:status).in_array(%w(active done failed)) }
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
                expect(TaskProcessingJob).to receive(:perform_later).with(subject)
                subject.save!
            end
        end

        context '.complete' do
            let!(:task) { create :task }

            it 'should be completed' do
                expect { task.complete }.to change(task, :status).from('active').to('done')
            end
        end

        context '.completed?' do
            let!(:task_1) { create :task, :done }
            let!(:task_2) { create :task }

            it 'should return true if status eq done' do
                expect(task_1.completed?).to eq true
            end

            it 'should return false if status not eq done' do
                expect(task_2.completed?).to eq false
            end
        end
    end
end
