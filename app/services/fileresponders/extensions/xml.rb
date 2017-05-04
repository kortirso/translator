require 'nokogiri' 

module Fileresponders
    module Extensions
        class Xml
            attr_reader :task, :xml_file, :base_array, :translation_service

            def initialize(task)
                @task = task
            end

            def processing
                return task.failure(101) unless File.file? task.file_name

                @xml_file = Nokogiri::XML(File.open(task.file_name))

                file_name = task.file_name.split('/').last
                task.update(from: file_name.split('.').size == 2 ? 'en' : file_name.split('.')[1].split('-')[0])
                @translation_service = Translations::BaseService.new(task)
                
                @base_array = xml_file.xpath("//data/value") + xml_file.xpath("//data/comment")
                true
            end

            def translating
                strings_for_translate
                translation_service.save_new_words
                save_to_file
                task.complete
            end

            private

            def strings_for_translate
                base_array.each { |value| value.children = translation_service.translate(value.children.to_s) }
            end

            def save_to_file
                File.write(change_file_name, xml_file.to_xml)
                File.open(change_file_name) { |f| task.result_file = f }
                task.save
            end

            def change_file_name
                translation_locale = Locale.find_by(code: task.to)
                file_name_array = task.file_name.split('.')
                file_name_array[-1] = "#{translation_locale.code}-#{translation_locale.country_code}." + file_name_array[-1]
                file_name_array.join('.')
            end
        end
    end
end