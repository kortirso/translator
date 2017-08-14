RSpec.describe Fileloaders::Xml do
    describe '.initialize' do
        let!(:task) { create :task }
        let(:loader) { Fileloaders::Xml.new(task) }

        it 'assigns task to @task' do
            expect(loader.task).to eq task
        end
    end

    describe '.load' do
        context 'if file does not exist' do
            let!(:task_without_file) { create :task }
            let(:loader) { Fileloaders::Xml.new(task_without_file) }

            it 'returns false' do
                expect(loader.load).to eq false
            end
        end

        context 'if file exists' do
            let!(:task_with_file) { create :task, :with_xml }
            let(:loader) { Fileloaders::Xml.new(task_with_file) }

            it 'returns string' do
                result = loader.load

                expect(result.is_a?(Nokogiri::XML::Document)).to eq true
            end

            it 'updates task.from' do
                expect { loader.load }.to change(task_with_file, :from).from('').to('en')
            end
        end
    end

    describe '.save' do
        let!(:locale) { create :locale, :ru }
        let!(:task_with_file) { create :task, :with_xml, to: 'ru' }
        let(:loader) { Fileloaders::Xml.new(task_with_file) }

        it 'executes task.save_temporary_file method' do
            result = loader.load
            expect_any_instance_of(Task).to receive(:save_temporary_file)

            loader.save(result)
        end
    end

    describe '.change_file_name' do
        let!(:task_with_file) { create :task, :with_xml }
        let(:loader) { Fileloaders::Xml.new(task_with_file) }

        it 'returns new file name like something.new_locale.xml' do
            responce = loader.send(:change_file_name)

            expect(responce).to eq "#{Rails.root}/public/uploads/tmp/strings.en.xml"
        end
    end
end
