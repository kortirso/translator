class WordSerializer < ActiveModel::Serializer
    attributes :id, :text
    has_many :translations
end