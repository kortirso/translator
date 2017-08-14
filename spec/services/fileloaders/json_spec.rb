RSpec.describe Fileloaders::Json do
    describe '.initialize' do
        let!(:task) { create :task }
        let(:loader) { Fileloaders::Json.new(task) }

        it 'assigns task to @task' do
            expect(loader.task).to eq task
        end

        it 'assigns nil to @locale' do
            expect(loader.locale).to eq nil
        end
    end

    describe '.load' do
        context 'if file does not exist' do
            let!(:task_without_file) { create :task }
            let(:loader) { Fileloaders::Json.new(task_without_file) }

            it 'returns false' do
                expect(loader.load).to eq false
            end
        end

        context 'if file is wrong' do
            let!(:task_with_file) { create :task, :with_wrong_json }
            let(:loader) { Fileloaders::Json.new(task_with_file) }

            it 'returns false' do
                expect(loader.load).to eq false
            end

            it 'updates task.status to failed' do
                expect { loader.load }.to change(task_with_file, :status).from('active').to('failed')
            end
        end

        context 'if file exists' do
            let!(:task_with_file) { create :task, :with_json }
            let(:loader) { Fileloaders::Json.new(task_with_file) }

            it 'returns hash' do
                result = loader.load

                expect(result.is_a?(Hash)).to eq true
            end

            it 'updates task.from' do
                expect { loader.load }.to change(task_with_file, :from).from('').to('ru')
            end
        end

        context 'if key is in the name' do
            let!(:task_with_file) { create :task, :with_json_keyed }
            let!(:locale_de) { create :locale, code: 'de', country_code: 'DE' }
            let(:loader) { Fileloaders::Json.new(task_with_file) }

            it 'returns hash' do
                result = loader.load

                expect(result.is_a?(Hash)).to eq true
            end

            it 'updates task.from' do
                expect { loader.load }.to change(task_with_file, :from).from('').to('de')
            end
        end
    end

    describe '.save' do
        let!(:task) { create :task, :with_json }
        let(:loader) { Fileloaders::Json.new(task) }

        it 'executes task.save_temporary_file method' do
            result = loader.load
            expect_any_instance_of(Task).to receive(:save_temporary_file)

            loader.save(result)
        end
    end

    describe '.change_file_name' do
        context 'for something.json file' do
            let!(:task) { create :task, :with_json }
            let(:loader) { Fileloaders::Json.new(task) }
            before { loader.load }

            it 'returns new file name like something.json' do
                responce = loader.send(:change_file_name)

                expect(responce).to eq "#{Rails.root}/public/uploads/tmp/data.json"
            end
        end

        context 'for locale.json file' do
            let!(:task) { create :task, :with_json_keyed }
            let(:loader) { Fileloaders::Json.new(task) }
            before { loader.load }

            it 'returns new file name like new_locale.json' do
                responce = loader.send(:change_file_name)

                expect(responce).to eq "#{Rails.root}/public/uploads/tmp/en.json"
            end
        end
    end
end
