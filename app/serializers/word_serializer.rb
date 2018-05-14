class WordSerializer < ActiveModel::Serializer
  attributes :id, :text, :translations

  def translations
    object.select_translations(locale: Locale.find_by(code: @instance_options[:locale])).keys
  end
end
