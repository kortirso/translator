class PhraseSerializer < ActiveModel::Serializer
  attributes :id, :current_value, :word

  def word
    WordSerializer.new(object.word, locale: @instance_options[:locale])
  end
end
