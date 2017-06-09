class TranslationSerializer < ActiveModel::Serializer
    attributes :id, :base_text, :result_text, :verified

    def base_text
        object.base.text
    end

    def result_text
        object.result.text
    end
end