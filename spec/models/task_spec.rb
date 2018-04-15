RSpec.describe Task, type: :model do
  it { should belong_to :user }
  it { should belong_to :framework }
  it { should have_many(:positions).dependent(:destroy) }
  it { should validate_presence_of :status }
  it { should validate_presence_of :framework_id }
  it { should validate_inclusion_of(:status).in_array(%w[verification active done failed]) }
  it { should validate_length_of(:from).is_equal_to(2) }
  it { should allow_value('').for(:from) }
  it { should validate_length_of(:to).is_equal_to(2) }

  it 'should be valid' do
    task = create :task

    expect(task).to be_valid
  end

  describe 'methods' do
    context '.file_name' do
      let!(:framework) { create :android_framework }

      context 'without file' do
        let!(:task) { create :task, framework: framework }

        it 'returns empty string' do
          expect(task.file_name).to eq ''
        end
      end

      context 'with file' do
        let!(:task) { create :task, :with_xml, framework: framework }

        it 'returns file name' do
          expect(task.file_name).to eq 'strings.xml'
        end
      end
    end

    context '.file_content' do
      let!(:framework) { create :android_framework }

      context 'without file' do
        let!(:task) { create :task, framework: framework }

        it 'returns empty string' do
          expect(task.file_content).to eq ''
        end
      end

      context 'with file' do
        let!(:task) { create :task, :with_xml, framework: framework }

        it 'returns file name' do
          expect(task.file_content).to_not eq ''
        end
      end
    end

    context '.temporary_file_name' do
      let!(:framework) { create :android_framework }

      context 'without file' do
        let!(:task) { create :task, framework: framework }

        it 'returns empty string' do
          expect(task.temporary_file_name).to eq ''
        end
      end

      context 'with file' do
      end
    end

    context '.temporary_file_content' do
      let!(:framework) { create :android_framework }

      context 'without file' do
        let!(:task) { create :task, framework: framework }

        it 'returns empty string' do
          expect(task.temporary_file_content).to eq ''
        end
      end

      context 'with file' do
      end
    end

    context '.result_file_name' do
      let!(:framework) { create :android_framework }

      context 'without file' do
        let!(:task) { create :task, framework: framework }

        it 'returns empty string' do
          expect(task.result_file_name).to eq ''
        end
      end

      context 'with file' do
      end
    end

    context '.result_file_content' do
      let!(:framework) { create :android_framework }

      context 'without file' do
        let!(:task) { create :task, framework: framework }

        it 'returns empty string' do
          expect(task.result_file_content).to eq ''
        end
      end

      context 'with file' do
      end
    end

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
        expect(task.failure(101)).to eq nil
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

      it 'returns nil if no error' do
        expect(task.error_message).to eq nil
      end

      %w[101 102 110 201 202 203 401 402].each do |error|
        it "returns specific error message for #{error}" do
          task.update(error: error)
          task.reload

          expect(task.error_message).to eq Task::ERRORS[error.to_s]
        end
      end
    end

    context '.save_file' do
      let!(:framework) { create :android_framework }
      let!(:task) { create :task, :with_xml, framework: framework }
      let(:text) { 'some text' }

      context 'for temp type' do
        let(:type) { 'temporary' }
        let(:filename) { "#{Rails.root}/spec/test_files/strings.#{task.to}.xml" }

        it 'saves temporary_file for task' do
          task.save_file(filename, text, type)
          task.reload

          expect(task.temporary_file.attached?).to eq true
        end
      end

      context 'for temp type' do
        let(:type) { 'result' }
        let(:filename) { "#{Rails.root}/spec/test_files/strings.#{task.to}.xml" }

        it 'saves result_file for task' do
          task.save_file(filename, text, type)
          task.reload

          expect(task.result_file.attached?).to eq true
        end
      end
    end
  end
end
