class Task < ApplicationRecord
    mount_uploader :file, FileUploader

    validates :uid, :status, :to, presence: true
    validates :from, length: { is: 2 }, allow_blank: true
    validates :to, length: { is: 2 }
    validates :status, inclusion: { in: %w(active done) }

    scope :for_guest, -> (guest_uid) { where uid: guest_uid }

    after_create :task_processing

    def file_name
        self.file.file.file
    end

    def complete
        self.status = 'done'
        save
    end

    def completed?
        status == 'done'
    end

    private

    def task_processing
        TaskProcessingService.execute(self) unless Rails.env.test?
        #TaskProcessingJob.perform_later(self)
    end
end
