module FileHandle
  module Convert
    module Concerns
      # Common methods for json-based converting
      module Jsonable
        def convert(hash_for_translate, parent = [])
          hash_for_translate.each do |key, value|
            if value.is_a?(Hash)
              convert(value, [key] + parent)
            else
              translated = get_values_for_translate(keys: [key] + parent, value: value)
              hash_merging(temporary, translated)
            end
          end
        end

        private def post_initialize(_args)
          @temporary = {}
        end

        private def get_values_for_translate(args)
          value = create_hash_for_value(args[:keys].shift, fragment_service.perform_sentence(args[:value]))
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
end
