class TaskSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :result_file_name, :from, :to, :status, :error, :error_message, :link_to_file

  def link_to_file
    return nil unless object.result_file.attached?
    rails_blob_url(object.result_file, disposition: 'attachment', only_path: true)
  end

  def error_message
    object.error_message
  end
end
