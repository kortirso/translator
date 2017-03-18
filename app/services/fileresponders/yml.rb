require 'yaml'

module Fileresponders
    class Yml
        attr_reader :task, :base_hash, :finish_hash, :translation_service

        def initialize(task)
            @task = task
            @finish_hash = {}
            @translation_service = TranslationsService.new(task)
        end

        def processing
            return false unless File.file? task.file_name

            yaml_file = YAML.load_file task.file_name
            return false if !yaml_file.kind_of?(Hash) || yaml_file.keys.count != 1 || yaml_file.values.count != 1

            base_locale = yaml_file.keys.first
            return false if task.from.present? && task.from != base_locale || task.to == base_locale
            task.from = base_locale if task.from.empty?

            @base_hash = yaml_file.values.first
            true
        end

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

        def save_to_file(hash_for_save = {})
            hash_for_save[task.to] = finish_hash
            File.open("#{Rails.root}/public/uploads/task/file/#{task.id}/#{task.to}.#{task.file_name.split('.').last}", 'w') { |f| f.write hash_for_save.to_yaml }
        end

        private

        def get_values_for_translate(params)
            value = create_hash_for_value(params[:keys].shift, translation_service.translate(params[:value]))
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
    end
end