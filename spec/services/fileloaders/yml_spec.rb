RSpec.describe Fileloaders::Yml do
    describe '.initialize' do
        let!(:task) { create :task }
        let(:loader) { Fileloaders::Yml.new(task) }

        it 'assigns task to @task' do
            expect(loader.task).to eq task
        end
    end

    describe '.load' do
        context 'if file does not exist' do
            let!(:task_without_file) { create :task }
            let(:loader) { Fileloaders::Yml.new(task_without_file) }

            it 'returns false' do
                expect(loader.load).to eq false
            end
        end

        context 'if file is wrong' do
            let!(:task_with_file) { create :task, :with_wrong_yml }
            let(:loader) { Fileloaders::Yml.new(task_with_file) }

            it 'returns false' do
                expect(loader.load).to eq false
            end

            it 'updates task.status to failed' do
                expect { loader.load }.to change(task_with_file, :status).from('active').to('failed')
            end
        end

        context 'if file exists' do
            let!(:task_with_file) { create :task, :with_yml }
            let(:loader) { Fileloaders::Yml.new(task_with_file) }

            it 'returns hash' do
                result = loader.load

                expect(result.is_a?(Hash)).to eq true
            end

            it 'updates task.from' do
                expect { loader.load }.to change(task_with_file, :from).from('').to('ru')
            end
        end
    end

    describe '.save' do
        let!(:task_with_file) { create :task, :with_yml }
        let(:loader) { Fileloaders::Yml.new(task_with_file) }

        it 'executes task.save_temporary_file method' do
            result = loader.load
            expect_any_instance_of(Task).to receive(:save_temporary_file)

            loader.save(result)
        end
    end

    describe '.change_file_name' do
        context 'for locale.yml file' do
            let!(:task_with_file) { create :task, :with_yml }
            let(:loader) { Fileloaders::Yml.new(task_with_file) }

            it 'returns new file name like new_locale.yml' do
                responce = loader.send(:change_file_name)

                expect(responce).to eq "#{Rails.root}/public/uploads/tmp/en.yml"
            end
        end

        context 'for something.locale.yml file' do
            let!(:task_with_file) { create :task, :with_long_yml, to: 'ru' }
            let(:loader) { Fileloaders::Yml.new(task_with_file) }

            it 'returns new file name like something.new_locale.yml' do
                responce = loader.send(:change_file_name)

                expect(responce).to eq "#{Rails.root}/public/uploads/tmp/hard_with_params.ru.yml"
            end
        end
    end
end
