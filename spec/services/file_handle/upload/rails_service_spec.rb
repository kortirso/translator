RSpec.describe FileHandle::Upload::RailsService do
    describe '.initialize' do
        context 'if file does not exist' do
            let!(:task_without_file) { create :task }

            it 'updates task with failed status' do
                FileHandle::Upload::RailsService.new(task: task_without_file)

                expect(task_without_file.status).to eq 'failed'
                expect(task_without_file.error).to eq 101
            end
        end

        context 'if file exists' do
            let!(:task) { create :task, :with_yml }
            let(:loader) { FileHandle::Upload::RailsService.new(task: task) }

            it 'assigns task to @task' do
                expect(loader.task).to eq task
            end
        end
    end

    describe '.load' do
        context 'for error situations' do
            let!(:task_with_wrong_yml) { create :task, :with_wrong_yml }
            let(:loader) { FileHandle::Upload::RailsService.new(task: task_with_wrong_yml) }

            it 'returns false' do
                allow(loader).to receive_message_chain(:check_file) { raise FileHandle::UploadService::AuthFailure, '110' }

                expect(loader.load).to eq false
            end

            it 'and updates task with failed status' do
                allow(loader).to receive_message_chain(:check_file) { raise FileHandle::UploadService::AuthFailure, '110' }
                loader.load

                expect(task_with_wrong_yml.status).to eq 'failed'
                expect(task_with_wrong_yml.error).to eq 110
            end
        end

        context 'for correct situations' do
            let!(:task) { create :task, :with_yml }
            let(:loader) { FileHandle::Upload::RailsService.new(task: task) }

            it 'returns hash with values' do
                expect(loader.load.is_a?(Hash)).to eq true
            end
        end
    end

    describe '.check_file' do
        context 'if file is incorrect' do
            let!(:task_with_wrong_yml) { create :task, :with_wrong_yml }
            let(:loader) { FileHandle::Upload::RailsService.new(task: task_with_wrong_yml) }

            it 'raises error' do
                expect { loader.send(:check_file) }.to raise_error(FileHandle::UploadService::AuthFailure)
            end
        end

        context 'if file is correct' do
            let!(:task) { create :task, :with_yml }
            let(:loader) { FileHandle::Upload::RailsService.new(task: task) }

            it 'does not raise error' do
                expect { loader.send(:check_file) }.to_not raise_error
            end

            it 'and returns nil' do
                expect(loader.send(:check_file)).to eq nil
            end
        end
    end

    describe '.locale_is_correct?' do
        let!(:task) { create :task, :with_yml }
        let(:loader) { FileHandle::Upload::RailsService.new(task: task) }

        context 'for incorrect locale' do
            it 'raises error' do
                expect { loader.send(:locale_is_correct?, 'ENG') }.to raise_error(FileHandle::UploadService::AuthFailure)
            end
        end

        context 'for locale like ru' do
            it 'does not raise error' do
                expect { loader.send(:locale_is_correct?, 'ru') }.to_not raise_error
            end

            it 'and returns true' do
                expect(loader.send(:locale_is_correct?, 'ru')).to eq true
            end
        end

        context 'for locale like nb-NO' do
            it 'does not raise error' do
                expect { loader.send(:locale_is_correct?, 'nb-NO') }.to_not raise_error
            end

            it 'and returns true' do
                expect(loader.send(:locale_is_correct?, 'nb-NO')).to eq true
            end
        end
    end

    describe '.task_update' do
        let!(:task) { create :task, :with_yml }
        let(:loader) { FileHandle::Upload::RailsService.new(task: task) }

        context 'for locale like ru' do
            it 'updates task with ru locale' do
                expect { loader.send(:task_update, 'ru') }.to change(task, :from).to('ru')
            end
        end

        context 'for locale like nb-NO' do
            it 'updates task with nb locale' do
                expect { loader.send(:task_update, 'nb-NO') }.to change(task, :from).to('nb')
            end
        end
    end
end
