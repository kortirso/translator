module Api
    module V1
        class LocalesController < Api::V1::BaseController
            def index
                render json: { locales: ActiveModel::Serializer::CollectionSerializer.new(Locale.all, each_serializer: LocaleSerializer) }
            end
        end
    end
end
