require 'nokogiri'

module Fileloaders
    # Fileloader for *.xml
    class Xml
        include Fileloaders::Base

        def load
            return false unless task_base_file_exist?
            xml_file = Nokogiri::XML(File.open(task.file_name))
            file_name = task.file_name.split('/')[-1]
            task.update(from: file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('.')[1])
            xml_file
        end

        def save(result, temp_file_name = change_file_name)
            File.write(temp_file_name, result)
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            file_name = task.file_name.split('/')[-1].gsub('.xml', ".#{task.to}.xml")
            "#{Rails.root}/public/uploads/tmp/#{file_name}"
        end
    end
end
