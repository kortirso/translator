class TaskSerializer < ActiveModel::Serializer
    attributes :id, :short_filename, :result_short_filename, :from, :to, :status, :error, :error_message

    def short_filename
        object.file.to_s.split('/').last
    end

    def result_short_filename
        object.result_file.to_s.split('/').last
    end

    def error_message
        object.error_message
    end
end