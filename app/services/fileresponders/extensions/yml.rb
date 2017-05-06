require 'yaml'

module Fileresponders
    module Extensions
        class Yml
            attr_reader :task, :base_hash, :finish_hash, :words_for_translate

            def initialize(task)
                @task = task
                @finish_hash = {}
                @words_for_translate = []
            end

            def processing
                return task.failure(101) unless File.file? task.file_name

                yaml_file = YAML.load_file task.file_name
                return task.failure(110) if !yaml_file.is_a?(Hash) || yaml_file.keys.count != 1 || yaml_file.values.count != 1

                task.update(from: yaml_file.keys.first)

                @base_hash = yaml_file.values.first
                true
            end

            def check_permissions
                true
            end

            def translating
                strings_for_translate([], base_hash)
                save_to_temporary_file
                Translations::TaskTranslationService.new({task: task}).translate({words_for_translate: words_for_translate})
            end

            private

            def strings_for_translate(parent, hash_for_translate)
                hash_for_translate.each do |key, value|
                    if value.is_a? Hash
                        strings_for_translate([key] + parent, value)
                    else
                        translated = get_values_for_translate({keys: [key] + parent, value: value})
                        hash_merging(finish_hash, translated)
                    end
                end
            end

            def get_values_for_translate(params)
                words_for_translate.push params[:value]
                value = create_hash_for_value(params[:keys].shift, "_###{params[:value]}##_")
                params[:keys].each { |key| value = create_hash_for_value(key, value) }
                value
            end

            def create_hash_for_value(key, value, h = {})
                h[key.to_s] = value
                h
            end

            def hash_merging(base_hash, merging_hash)
                base_hash.merge!(merging_hash) { |key, oldval, newval| hash_merging(base_hash[key], merging_hash[key]) }
            end

            def save_to_temporary_file(hash_for_save = {})
                hash_for_save[task.to] = finish_hash
                temp_file_name = change_file_name
                File.write(temp_file_name, hash_for_save.to_yaml)
                File.open(temp_file_name) { |f| task.temporary_file = f }
                task.save
                File.delete(temp_file_name)
            end

            def change_file_name
                file_name_array = task.file_name.split('/')
                file_name_array[-1] = "#{task.to}.#{file_name_array[-1].split('.')[1]}"
                file_name_array.join('/')
            end
        end
    end
end