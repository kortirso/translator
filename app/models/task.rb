# Represents task with file for translation
class Task < ApplicationRecord
    ERRORS = {
        '101' => 'file does not exist',
        '102' => 'file is incorrect',
        '103' => 'file uploading error',
        '110' => 'bad file structure',
        '201' => 'direction for translating does not exist',
        '202' => 'locale definition error (see file structure below)',
        '203' => 'your language is not supported yet',
        '301' => 'limit is exceeded (100 lines)',
        '302' => 'limit is exceeded (200 lines)',
        '401' => 'loading file error (message sent to developers)',
        '402' => 'prepare translation error (message sent to developers)'
    }.freeze

    mount_uploader :file, FileUploader
    mount_uploader :temporary_file, FileUploader
    mount_uploader :result_file, FileUploader

    belongs_to :user, optional: true
    belongs_to :framework

    has_many :positions, dependent: :destroy
    has_many :translations, through: :positions

    validates :status, :framework_id, presence: true
    validates :from, length: { is: 2 }, allow_blank: true
    validates :to, length: { is: 2 }, allow_blank: true
    validates :status, inclusion: { in: %w[verification checked active done failed] }

    scope :for_guest, ->(guest_uid) { where uid: guest_uid, user_id: nil }

    after_commit :task_processing, on: :create

    def file_name
        return '' if file.file.nil?
        file.file.file
    end

    def result_file_name
        return '' if result_file.file.nil?
        result_file.file.file
    end

    def double_translating
        update double: true
        true
    end

    def activate(translation_params)
        update status: 'active'
        TaskUpdatingJob.perform_later(translation_params, self)
    end

    def complete
        self.status = 'done'
        save
    end

    def failure(code)
        update status: 'failed', error: code
        false
    end

    def completed?
        status == 'done'
    end

    def failed?
        status == 'failed'
    end

    def save_temporary_file(file_name)
        File.open(file_name) { |f| self.temporary_file = f }
        save
        File.delete(file_name)
    end

    def error_message
        ERRORS[error.to_s]
    end

    def direction(value)
        case value
            when :straight then "#{from}-#{to}"
            when :reverse then "#{to}-#{from}"
        end
    end

    private

    def task_processing
        TaskProcessingJob.perform_later(self)
    end
end
