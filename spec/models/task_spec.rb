RSpec.describe Task, type: :model do
    it { should belong_to :user }
    it { should belong_to :framework }
    it { should have_many(:positions).dependent(:destroy) }
    it { should have_many(:translations).through(:positions) }
    it { should validate_presence_of :status }
    it { should validate_presence_of :framework_id }
    it { should validate_inclusion_of(:status).in_array(%w[verification checked active done failed]) }
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
                expect(TaskProcessingJob).to receive(:perform_later)
                subject.save!
            end
        end

        context '.activate' do
            let!(:task) { create :task, :done }

            it 'should perform_later job TaskUpdatingJob' do
                expect(TaskUpdatingJob).to receive(:perform_later).with({}, task)

                task.activate({})
            end

            it 'updates task status to active' do
                expect { task.activate({}) }.to change(task, :status).from('done').to('active')
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

        context '.direction' do
            let!(:task) { create :task }

            it 'returns straight direction if :straight' do
                expect(task.direction(:straight)).to eq "#{task.from}-#{task.to}"
            end

            it 'returns reverse direction if :reverse' do
                expect(task.direction(:reverse)).to eq "#{task.to}-#{task.from}"
            end
        end

        context '.error_message' do
            let!(:task) { create :task }

            it 'returns string with error' do
                expect(task.error_message.is_a?(String)).to eq true
            end

            it 'returns specific error message for 101' do
                task.update(error: 101)
                task.reload

                expect(task.error_message).to eq 'file does not exist'
            end

            it 'returns specific error message for 102' do
                task.update(error: 102)
                task.reload

                expect(task.error_message).to eq 'file is incorrect'
            end

            it 'returns specific error message for 110' do
                task.update(error: 110)
                task.reload

                expect(task.error_message).to eq 'bad file structure'
            end

            it 'returns specific error message for 201' do
                task.update(error: 201)
                task.reload

                expect(task.error_message).to eq 'direction for translating does not exist'
            end

            it 'returns specific error message for 202' do
                task.update(error: 202)
                task.reload

                expect(task.error_message).to eq 'locale definition error (see file structure below)'
            end

            it 'returns specific error message for 203' do
                task.update(error: 203)
                task.reload

                expect(task.error_message).to eq 'your language is not supported yet'
            end

            it 'returns specific error message for 401' do
                task.update(error: 401)
                task.reload

                expect(task.error_message).to eq 'loading file error (message sent to developers)'
            end

            it 'returns specific error message for 402' do
                task.update(error: 402)
                task.reload

                expect(task.error_message).to eq 'prepare translation error (message sent to developers)'
            end
        end
    end
end
