class PositionSerializer < ActiveModel::Serializer
  attributes :id, :base_value, :temp_value, :translator_value, :current_value, :phrases_value
end
