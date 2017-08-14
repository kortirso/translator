require 'nokogiri'

module Fileloaders
    # Fileloader for *.resx
    class Resx
        include Fileloaders::Base

        def load
            return false unless task_base_file_exist?
            xml_file = Nokogiri::XML(File.open(task.file_name))
            file_name = task.file_name.split('/')[-1]
            locale = file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('-')[0]
            return task.failure(202) if locale.size != 2
            task.update(from: locale)
            xml_file
        end

        def save(result, temp_file_name = change_file_name)
            File.write(temp_file_name, result)
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            translation_locale = Locale.find_by(code: task.to)
            file_name = task.file_name.split('/')[-1].split('.')[0]
            "#{Rails.root}/public/uploads/tmp/#{file_name}.#{translation_locale.code}-#{translation_locale.country_code}.resx"
        end
    end
end
