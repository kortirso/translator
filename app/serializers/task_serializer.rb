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

  class FullData < self
    attributes :file_name, :framework_name, :sentences_amount, :link_to_source_file, :created_at, :updated_at

    def framework_name
      object.framework.name
    end

    def sentences_amount
      object.positions.size
    end

    def link_to_source_file
      return nil unless object.file.attached?
      rails_blob_url(object.file, disposition: 'attachment', only_path: true)
    end

    def created_at
      object.created_at.strftime('%Y.%m.%d %H:%M')
    end

    def updated_at
      object.updated_at.strftime('%Y.%m.%d %H:%M')
    end
  end
end
