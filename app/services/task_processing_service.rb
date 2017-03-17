require 'yaml'

class TaskProcessingService
    attr_reader :task, :yaml_base_hash, :yaml_finish_hash

    def initialize(task)
        @task = task
        @yaml_finish_hash = {}
    end

    def execute
        return false unless yaml_processing
        return false unless strings_for_translate(nil, yaml_base_hash)
        puts yaml_finish_hash
=begin
done 1. Проверка и парсинг yml, преобразование файла в хэш
done 1.1. Поиск значения-строки по значениям хэша с рекурсией с мгновенным переводом
2. Перевод всех значений в хэше через яндекс.переводчик
done 3. Создание нового хэша с переводом
4. Сохранение перевода в файл
5. Вывод файла на главной странице (окончание обработки таска)
=end
    end

    private

    def yaml_processing
        return false unless File.file? task.yaml.file.file

        yaml_file = YAML.load_file(task.yaml.file.file)
        return false if !yaml_file.kind_of?(Hash) || yaml_file.keys.count != 1 || yaml_file.values.count != 1

        base_locale = yaml_file.keys.first
        return false if task.from.present? && task.from != base_locale
        task.from = base_locale if task.from.empty?

        @yaml_base_hash = yaml_file.values.first
    end

    def strings_for_translate(parent, myHash)
        myHash.each do |key, value|
            if value.is_a?(Hash)
                parent = parent.nil? ? key : "#{parent},#{key}"
                strings_for_translate(parent, value)
            else
                translated = get_values_for_translate({keys: "#{parent.nil? ? '' : parent},#{key}".split(',').delete_if{ |p| p.empty? }.reverse, value: value})
                hash_merging(yaml_finish_hash, translated)
            end
        end
    end

    def get_values_for_translate(params)
        value = create_hash_for_value(params[:keys].shift, translate_word(params[:value]))
        params[:keys].each { |key| value = create_hash_for_value(key, value) }
        value
    end

    def create_hash_for_value(key, value, h = {})
        h[key.to_sym] = value
        h
    end

    def hash_merging(base_hash, merging_hash)
        base_hash.merge!(merging_hash) { |key, oldval, newval| hash_merging(base_hash[key], merging_hash[key]) }
    end

    def translate_word(word)
        "!#{word}"
    end
end