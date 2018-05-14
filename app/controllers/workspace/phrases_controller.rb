module Workspace
  class PhrasesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[update]
    before_action :authenticate_user!
    before_action :find_phrase, only: %i[update]

    def update
      @phrase.update(phrase_params)
      @phrase.position.update_phrases_value
      render json: @phrase.position, status: 200
    end

    private def find_phrase
      @phrase = Phrase.find_by(id: params[:id])
      render json: { error: 'Phrase does not exist' }, status: 404 if @phrase.nil?
    end

    private def phrase_params
      params.require(:phrase).permit(:current_value)
    end
  end
end
