RSpec.describe Fileloaders::Php do
    describe '.initialize' do
        let!(:task) { create :task }
        let(:loader) { Fileloaders::Php.new(task) }

        it 'assigns task to @task' do
            expect(loader.task).to eq task
        end
    end

    describe '.load' do
        context 'if file does not exist' do
            let!(:task_without_file) { create :task }
            let(:loader) { Fileloaders::Php.new(task_without_file) }

            it 'returns false' do
                expect(loader.load).to eq false
            end
        end

        context 'if file exists' do
            let!(:task_with_file) { create :task, :with_php }
            let(:loader) { Fileloaders::Php.new(task_with_file) }

            it 'returns string' do
                result = loader.load

                expect(result.is_a?(String)).to eq true
            end

            it 'updates task.from' do
                expect { loader.load }.to change(task_with_file, :from).from('').to('en')
            end
        end
    end

    describe '.save' do
        let!(:task_with_file) { create :task, :with_php }
        let(:loader) { Fileloaders::Php.new(task_with_file) }

        it 'executes task.save_temporary_file method' do
            result = loader.load
            expect_any_instance_of(Task).to receive(:save_temporary_file)

            loader.save(result)
        end
    end

    describe '.change_file_name' do
        let!(:task_with_file) { create :task, :with_php, to: 'ru' }
        let(:loader) { Fileloaders::Php.new(task_with_file) }

        it 'returns new file name like something.new_locale.php' do
            responce = loader.send(:change_file_name)

            expect(responce).to eq "#{Rails.root}/public/uploads/tmp/app.ru.php"
        end
    end
end
