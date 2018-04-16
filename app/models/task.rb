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

  has_one_attached :file
  has_one_attached :temporary_file
  has_one_attached :result_file

  belongs_to :user, optional: true
  belongs_to :framework

  has_many :positions, dependent: :destroy
  has_many :phrases, through: :positions

  validates :status, :framework, presence: true
  validates :from, length: { is: 2 }, allow_blank: true
  validates :to, length: { is: 2 }, allow_blank: true
  validates :status, inclusion: { in: %w[verification active done failed] }

  scope :for_guest, ->(guest_uid) { where uid: guest_uid, user_id: nil }

  after_commit :task_processing, on: :create

  def file_name
    return '' unless file.attached?
    file.attachment.blob.filename.to_s
  end

  def file_content
    return '' unless file.attached?
    file.attachment.blob.download
  end

  def temporary_file_name
    return '' unless temporary_file.attached?
    temporary_file.attachment.blob.filename
  end

  def temporary_file_content
    return '' unless temporary_file.attached?
    temporary_file.attachment.blob.download
  end

  def result_file_name
    return '' unless result_file.attached?
    result_file.attachment.blob.filename
  end

  def result_file_content
    return '' unless result_file.attached?
    result_file.attachment.blob.download
  end

  def double_translating
    update(double: true)
  end

  def phrases_for_translation
    phrases.collect { |phrase| phrase.word.text }
  end

  def activate(translation_params)
    update(status: 'active')
    TaskUpdatingJob.perform_later(translation_params, self)
  end

  def complete
    update(status: 'done')
  end

  def failure(code)
    update(status: 'failed', error: code)
    nil
  end

  def completed?
    status == 'done'
  end

  def failed?
    status == 'failed'
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

  def save_file(filename, text, type)
    File.open(filename, 'w') { |f| f.write(text) }
    attach_type = type == 'result' ? result_file : temporary_file
    attach_type.attach(io: File.open(filename), filename: filename.split('/')[-1])
    complete if type == 'result'
    File.delete(filename)
  end

  private def task_processing
    TaskProcessingJob.perform_later(self)
  end
end
