class Task < ApplicationRecord
    mount_uploader :file, FileUploader
    mount_uploader :result_file, FileUploader

    belongs_to :user, optional: true

    has_many :positions, dependent: :destroy
    has_many :translations, through: :positions

    validates :uid, :status, :to, :file, presence: true
    validates :from, length: { is: 2 }, allow_blank: true
    validates :to, length: { is: 2 }
    validates :status, inclusion: { in: %w(active done) }

    scope :for_guest, -> (guest_uid) { where uid: guest_uid }

    after_create :task_processing

    def file_name
        self.file.file.file
    end

    def result_file_name
        self.result_file.file.file
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
        #TaskProcessingJob.perform_later(self)
        TaskProcessingService.execute(task)
    end
end
