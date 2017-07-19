# Represents task with file for translation
class Task < ApplicationRecord
    mount_uploader :file, FileUploader
    mount_uploader :temporary_file, FileUploader
    mount_uploader :result_file, FileUploader

    belongs_to :user, optional: true

    has_many :positions, dependent: :destroy
    has_many :translations, through: :positions

    validates :uid, :status, :to, presence: true
    validates :from, length: { is: 2 }, allow_blank: true
    validates :to, length: { is: 2 }
    validates :status, inclusion: { in: %w[active done failed] }

    scope :for_guest, ->(guest_uid) { where uid: guest_uid, user_id: nil }

    after_create :task_processing

    def file_name
        return '' if file.file.nil?
        file.file.file
    end

    def result_file_name
        return '' if result_file.file.nil?
        result_file.file.file
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
        case error
            when 101 then 'file does not exist'
            when 102 then 'fileresponder does not exist'
            when 110 then 'bad YML structure'
            when 201 then 'direction for translating does not exist'
            when 301 then 'limit is exceeded (100 lines)'
            when 302 then 'limit is exceeded (200 lines)'
            else ''
        end
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
