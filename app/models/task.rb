class Task < ApplicationRecord
    mount_uploader :yaml, YamlUploader

    validates :uid, :status, presence: true
    validates :status, inclusion: { in: %w(active done) }
end
