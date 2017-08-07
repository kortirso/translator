RSpec.describe Task, type: :model do
    it { should belong_to :user }
    it { should have_many(:positions).dependent(:destroy) }
    it { should have_many(:translations).through(:positions) }
    it { should validate_presence_of :status }
    it { should validate_presence_of :to }
    it { should validate_inclusion_of(:status).in_array(%w[active done failed]) }
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

        context '.double_translating' do
            let!(:task) { create :task }

            it 'updates task to use double translating' do
                expect { task.double_translating }.to change(task, :double).from(false).to(true)
            end

            it 'returns true' do
                expect(task.double_translating).to eq true
            end
        end

        context '.complete' do
            let!(:task) { create :task }

            it 'updates task status to done' do
                expect { task.complete }.to change(task, :status).from('active').to('done')
            end
        end

        context '.completed?' do
            let!(:task_1) { create :task, :done }
            let!(:task_2) { create :task }

            it 'returns true if status eq done' do
                expect(task_1.completed?).to eq true
            end

            it 'returns false if status not eq done' do
                expect(task_2.completed?).to eq false
            end
        end

        context '.failure' do
            let!(:task) { create :task }

            it 'updates task status to failed' do
                expect { task.failure(101) }.to change(task, :status).from('active').to('failed')
            end

            it 'returns false' do
                expect(task.failure(101)).to eq false
            end
        end

        context '.failed?' do
            let!(:task_1) { create :task, :failed }
            let!(:task_2) { create :task }

            it 'returns true if status eq failed' do
                expect(task_1.failed?).to eq true
            end

            it 'returns false if status not eq failed' do
                expect(task_2.failed?).to eq false
            end
        end
    end
end
