module Fileresponders
    # Fileresponder for *.yml
    class Yml
        include Fileresponders::Base

        def initialize(task)
            super(task)
            @result = {}
        end

        def check_permissions
            true
        end

        private

        def strings_for_translate(parent = [], hash_for_translate = base_data)
            hash_for_translate.each do |key, value|
                if value.is_a? Hash
                    strings_for_translate([key] + parent, value)
                else
                    translated = get_values_for_translate(keys: [key] + parent, value: value)
                    hash_merging(result, translated)
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

        def hash_merging(base_data, merging_hash)
            base_data.merge!(merging_hash) { |key, _oldval, _newval| hash_merging(base_data[key], merging_hash[key]) }
        end
    end
end
