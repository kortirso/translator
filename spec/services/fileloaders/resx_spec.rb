RSpec.describe Fileloaders::Resx do
    describe '#initialize' do
        let!(:task) { create :task }
        let(:loader) { Fileloaders::Resx.new(task) }

        it 'should assign task to @task' do
            expect(loader.task).to eq task
        end
    end

    describe '#load' do
        context 'if file does not exist' do
            let!(:task_without_file) { create :task }
            let(:loader) { Fileloaders::Resx.new(task_without_file) }

            it 'should return false' do
                expect(loader.load).to eq false
            end
        end

        context 'if file exists' do
            let!(:task_with_file) { create :task, :with_resx }
            let(:loader) { Fileloaders::Resx.new(task_with_file) }

            it 'should return string' do
                result = loader.load

                expect(result.is_a? Nokogiri::XML::Document).to eq true
            end

            it 'should update task.from' do
                expect { loader.load }.to change(task_with_file, :from).from('').to('en')
            end
        end
    end

    describe '#save' do
        let!(:locale) { create :locale, :ru }
        let!(:task_with_file) { create :task, :with_resx, to: 'ru' }
        let(:loader) { Fileloaders::Resx.new(task_with_file) }

        it 'should execute task.save_temporary_file method' do
            result = loader.load
            expect_any_instance_of(Task).to receive(:save_temporary_file)

            loader.save(result)
        end
    end
end