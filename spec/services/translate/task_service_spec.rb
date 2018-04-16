RSpec.describe Translate::TaskService do
  let!(:locale_en) { create :locale, :en }
  let!(:locale_ru) { create :locale, :ru }
  let!(:task) { create :task, :with_yml, from: 'ru' }
  let(:tasker) { Translate::TaskService.new(task: task) }

  describe '.initialize' do
    it 'assigns task to @task' do
      expect(tasker.task).to eq task
    end

    it 'assigns Translate::WordService object to @word_service' do
      expect(tasker.word_service.is_a?(Translate::WordService)).to eq true
    end
  end

  describe 'methods' do
    context '.translate' do
      it 'calls save_new_words method for word_service' do
        expect_any_instance_of(Translate::WordService).to receive(:save_new_words)

        tasker.translate
      end
    end

    context '.translate_word' do
      it 'calls translate method for word_service' do
        expect_any_instance_of(Translate::WordService).to receive(:translate)

        tasker.send(:translate_word, 'Hello')
      end
    end
  end
end
