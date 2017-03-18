class Task < ApplicationRecord
    mount_uploader :file, FileUploader

    validates :uid, :status, :to, presence: true
    validates :from, length: { is: 2 }, allow_blank: true
    validates :to, length: { is: 2 }
    validates :status, inclusion: { in: %w(active done) }

    after_create :task_processing

    def file_name
        self.file.file.file
    end

    def complete
        status = 'done'
        save
    end

    private

    def task_processing
        TaskProcessingService.execute(self) unless Rails.env.test?
    end
end
