require 'yaml'

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

    describe '.file_is_correct?' do
        context 'for incorrect file' do
            let!(:task_with_file) { create :task, :with_wrong_yml }
            let(:loader) { Fileloaders::Yml.new(task_with_file) }
            let(:yaml_file) { YAML.load_file task_with_file.file_name }

            it 'returns false' do
                expect(loader.send(:file_is_correct?, yaml_file)).to eq false
            end
        end

        context 'for correct file' do
            let!(:task_with_file) { create :task, :with_yml }
            let(:loader) { Fileloaders::Yml.new(task_with_file) }
            let(:yaml_file) { YAML.load_file task_with_file.file_name }

            it 'returns false' do
                expect(loader.send(:file_is_correct?, yaml_file)).to eq true
            end
        end
    end

    describe '.locale_is_correct?' do
        let!(:task_with_file) { create :task, :with_yml }
        let(:loader) { Fileloaders::Yml.new(task_with_file) }

        context 'for incorrect locale' do
            it "returns false for 'enu'" do
                expect(loader.send(:locale_is_correct?, 'enu')).to eq false
            end

            it "returns false for 'enu-GB'" do
                expect(loader.send(:locale_is_correct?, 'enu-GB')).to eq false
            end
        end

        context 'for correct locale' do
            it "returns true for 'en'" do
                expect(loader.send(:locale_is_correct?, 'en')).to eq true
            end

            it "returns true for 'en-GB'" do
                expect(loader.send(:locale_is_correct?, 'en-GB')).to eq true
            end
        end
    end
end
