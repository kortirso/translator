require 'yaml'
require 'fileutils'

module FileHandle
    module Convert
        # FileUploader for *.yml
        class RailsService < FileHandle::ConvertService
            attr_reader :result

            def post_initialize(_args)
                @result = {}
            end

            def convert(hash_for_translate, parent = [])
                hash_for_translate.each do |key, value|
                    if value.is_a?(Hash)
                        strings_for_translate([key] + parent, value)
                    else
                        translated = get_values_for_translate(keys: [key] + parent, value: value)
                        hash_merging(result, translated)
                    end
                end
                true
            rescue
                raise AuthFailure, '402'
            end

            private def get_values_for_translate(args)
                checked = sentence_service.call(args[:value])
                words_for_translate.push checked[:blocks_for_translate]
                value = create_hash_for_value(args[:keys].shift, checked[:sentence])
                args[:keys].each { |key| value = create_hash_for_value(key, value) }
                value
            end

            private def create_hash_for_value(key, value, h = {})
                h[key.to_s] = value
                h
            end

            private def hash_merging(base_data, merging_hash)
                base_data.merge!(merging_hash) { |key, _oldval, _newval| hash_merging(base_data[key], merging_hash[key]) }
            end
        end
    end
end
