class Task < ApplicationRecord
    mount_uploader :yaml, YamlUploader

    validates :uid, :status, :to, presence: true
    validates :from, length: { is: 2 }, allow_blank: true
    validates :to, length: { is: 2 }
    validates :status, inclusion: { in: %w(active done) }

    after_create :task_processing

    private

    def task_processing
        TaskProcessingService.new(self).execute
    end
end
