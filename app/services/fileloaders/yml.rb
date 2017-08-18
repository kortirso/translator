require 'yaml'
require 'fileutils'

module Fileloaders
    # Fileloader for *.yml
    class Yml
        include Fileloaders::Base

        def load
            return false unless task_base_file_exist?
            remove_comments(task.file_name)
            yaml_file = YAML.load_file task.file_name
            return task.failure(110) unless file_is_correct?(yaml_file)
            return task.failure(202) unless locale_is_correct?(yaml_file.keys.first)
            task.update(from: yaml_file.keys.first)
            yaml_file.values.first
        end

        def save(result, temp_file_name = change_file_name)
            File.write(temp_file_name, { task.to => result }.to_yaml(line_width: 500))
            task.save_temporary_file(temp_file_name)
        end

        private

        def change_file_name
            file_name = task.file_name.split('/')[-1]
            file_name = file_name.split('.').size <= 2 ? "#{task.to}.yml" : "#{file_name.split('.')[0]}.#{task.to}.yml"
            "#{Rails.root}/public/uploads/tmp/#{file_name}"
        end

        def remove_comments(file_name)
            open(file_name, 'r') do |f|
                open("#{file_name}.tmp", 'w') do |f2|
                    f.each_line do |line|
                        f2.write(line) unless line.start_with? '#'
                    end
                end
            end
            FileUtils.mv "#{file_name}.tmp", file_name
        end

        def file_is_correct?(file)
            return false unless file.is_a?(Hash)
            return false unless file.keys.count == 1
            true
        end

        def locale_is_correct?(locale)
            return true if locale.size == 2
            return true if locale.split('-')[0].size == 2
            false
        end
    end
end
