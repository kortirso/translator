module Workspace
  class PositionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[update]
    before_action :authenticate_user!
    before_action :find_position, only: %i[update]

    def update
      @position.update(position_params)
      render json: @position, status: 200
    end

    private def find_position
      @position = Position.find_by(id: params[:id])
      render_not_found if @position.nil?
    end

    private def position_params
      params.require(:position).permit(:current_value)
    end
  end
end
