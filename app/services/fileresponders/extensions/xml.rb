require 'nokogiri' 

module Fileresponders
    module Extensions
        class Xml
            GUEST_LIMIT = 50
            USER_LIMIT = 100

            attr_reader :task, :words_for_translate, :xml_file, :base_array, :translation_service

            def initialize(task)
                @task = task
                @words_for_translate = []
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

            def check_permissions
                return task.failure(301) if task.user.nil? && base_array.size > GUEST_LIMIT
                return task.failure(302) if task.user.present? && base_array.size > USER_LIMIT
                true
            end

            def translating
                strings_for_translate
                save_to_temporary_file
                Translations::TaskTranslationService.new({task: task}).translate({words_for_translate: words_for_translate})
            end

            private

            def strings_for_translate
                base_array.each do |value|
                    words_for_translate.push value.children.to_s
                    value.children = "_###{value.children.to_s}##_"
                end
            end

            def save_to_temporary_file
                temp_file_name = change_file_name
                File.write(temp_file_name, xml_file.to_xml)
                File.open(temp_file_name) { |f| task.temporary_file = f }
                task.save
                File.delete(temp_file_name)
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