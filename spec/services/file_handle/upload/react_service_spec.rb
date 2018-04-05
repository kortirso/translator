RSpec.describe FileHandle::Upload::ReactService do
  describe '.initialize' do
    context 'if file does not exist' do
      let!(:task_without_file) { create :task }

      it 'raises error' do
        expect { FileHandle::Upload::ReactService.new(task: task_without_file) }.to raise_error(StandardError)
      end
    end

    context 'if file exists' do
      let!(:task) { create :task, :with_json }
      let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

      it 'assigns task to @task' do
        expect(loader.task).to eq task
      end

      it 'assigns data from file to @uploaded_file' do
        expect(loader.uploaded_file.is_a?(Hash)).to eq true
      end
    end
  end

  describe '.load' do
    context 'for correct situations' do
      let!(:task) { create :task, :with_json }
      let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

      it 'returns hash with values' do
        expect(loader.load.is_a?(Hash)).to eq true
      end
    end
  end

  describe '.check_file' do
    context 'if file is correct' do
      let!(:task) { create :task, :with_json }
      let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

      it 'does not raise error' do
        expect { loader.send(:check_file) }.to_not raise_error
      end

      it 'and returns nil' do
        expect(loader.send(:check_file)).to eq nil
      end
    end
  end

  describe '.locale_is_correct?' do
    context 'for incorrect locale' do
      let!(:task) { create :task, :with_wrong_json }
      let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

      it 'raises error' do
        expect { loader.send(:locale_is_correct?) }.to raise_error(StandardError)
      end
    end

    context 'for locale like en' do
      let!(:task) { create :task, :with_json }
      let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

      it 'does not raise error' do
        expect { loader.send(:locale_is_correct?) }.to_not raise_error
      end

      it 'and returns true' do
        expect(loader.send(:locale_is_correct?)).to eq true
      end
    end
  end

  describe '.task_update' do
    let!(:task) { create :task, :with_json }
    let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

    context 'for locale like ru' do
      it 'updates task with ru locale' do
        expect { loader.send(:task_update) }.to change(task, :from).to('ru')
      end
    end
  end

  describe '.locale' do
    context 'for files with standard locale' do
      let!(:task) { create :task, :with_json }
      let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

      it 'returns default de locale' do
        expect(loader.send(:locale)).to eq 'ru'
      end
    end
  end

  describe '.file_name' do
    let!(:task) { create :task, :with_json }
    let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

    it 'returns file name' do
      expect(loader.send(:file_name)).to eq 'data.json'
    end
  end

  describe '.returned_value' do
    let!(:task) { create :task, :with_json }
    let(:loader) { FileHandle::Upload::ReactService.new(task: task) }

    it 'returns data from file' do
      expect(loader.send(:returned_value)).to eq loader.uploaded_file.values.first
    end
  end
end
