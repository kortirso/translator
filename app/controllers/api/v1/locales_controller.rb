class Api::V1::LocalesController < Api::V1::BaseController
    def index
        render json: { locales: ActiveModel::Serializer::CollectionSerializer.new(Locale.all, each_serializer: LocaleSerializer) }
    end
end