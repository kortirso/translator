class Task < ApplicationRecord
    mount_uploader :file, FileUploader
    mount_uploader :result_file, FileUploader

    belongs_to :user, optional: true

    has_many :positions, dependent: :destroy
    has_many :translations, through: :positions

    validates :uid, :status, :to, presence: true
    validates :from, length: { is: 2 }, allow_blank: true
    validates :to, length: { is: 2 }
    validates :status, inclusion: { in: %w(active done failed) }

    scope :for_guest, -> (guest_uid) { where uid: guest_uid }

    after_create :task_processing

    def file_name
        self.file.file.file
    end

    def result_file_name
        self.result_file.file.file
    end

    def complete
        self.update status: 'done'
    end

    def failure(code)
        self.update status: 'failed', error: code
        false
    end

    def completed?
        status == 'done'
    end

    def failed?
        status == 'failed'
    end

    def error_message
        case error
            when 101 then 'file does not exist'
            when 102 then 'fileresponder does not exist'
            when 110 then 'bad YML structure'
            when 201 then 'direction for translating does not exist'
            else ''
        end
    end

    private

    def task_processing
        TaskProcessingJob.perform_later(self)
    end
end
