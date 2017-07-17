module Api
    module V1
        class TranslationsController < Api::V1::BaseController

            def index
                words = Locale.find_by(code: params[:language]).words.text_begins_with(params[:letter]).includes(:translations)
                render json: { words: ActiveModel::Serializer::CollectionSerializer.new(words, each_serializer: WordSerializer) }
            end

            def update
                Translation.find_by(id: params[:id]).update(verified: verified_params[:verified])
            end

            private

            def verified_params
                params.require(:translation).permit(:verified)
            end
        end
    end
end
