class Api::V1::TranslationsController < Api::V1::BaseController
    before_action :authenticate_token

    def index
        words = Locale.find_by(code: params[:language]).words.text_begins_with(params[:letter]).includes(:translations)
        
        render json: { words: ActiveModel::Serializer::CollectionSerializer.new(words, each_serializer: WordSerializer) }
    end
end