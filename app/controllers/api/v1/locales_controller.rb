module Api
    module V1
        class LocalesController < Api::V1::BaseController
            skip_before_action :authenticate
            
            def index
                render json: { locales: ActiveModel::Serializer::CollectionSerializer.new(Locale.all, each_serializer: LocaleSerializer) }, status: 200
            end
        end
    end
end
