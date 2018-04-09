require 'yaml'

module FileHandle
  module Save
    # Saving service for Ruby on Rails framework
    class RailsService < FileHandle::SaveService
      def save_temporary(args = {})
        task.save_file(temporary_file_name, { task.to => args[:data] }.to_yaml(line_width: 500), 'temporary')
      end

      private def define_filename(type)
        file_name = task.file_name
        file_name = file_name.split('.').size <= 2 ? '' : file_name.split('.')[0]
        "#{TEMP_FOLDER}#{task.id}.#{type}.#{file_name}.#{task.to}.yml"
      end
    end
  end
end
