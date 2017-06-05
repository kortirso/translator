class Api::V1::TranslationsController < Api::V1::BaseController
    before_action :authenticate_token

    def index
        words = Locale.find_by(code: params[:language]).words.text_begins_with(params[:letter]).pluck(:id)
        translations = Translation.where(base_id: words).includes(:base, :result)
        
        render json: { translations: ActiveModel::Serializer::CollectionSerializer.new(translations, each_serializer: TranslationSerializer) }
    end
end