require 'nokogiri' 

module Fileloaders
    class Xml
        include Fileloaders::Base

        attr_reader :xml_file

        def load
            return false unless task_base_file_exist?
            @xml_file = Nokogiri::XML(File.open(task.file_name))
            file_name = task.file_name.split('/').last
            task.update(from: file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('-')[0])
            xml_file.xpath("//data/value") + xml_file.xpath("//data/comment")
        end

        def save
            temp_file_name = change_file_name
            File.write(temp_file_name, xml_file.to_xml)
            File.open(temp_file_name) { |f| task.temporary_file = f }
            task.save
            File.delete(temp_file_name)
        end

        private

        def change_file_name
            translation_locale = Locale.find_by(code: task.to)
            file_name_array = task.file_name.split('.')
            file_name_array[-1] = "#{translation_locale.code}-#{translation_locale.country_code}." + file_name_array[-1]
            file_name_array.join('.')
        end
    end
end