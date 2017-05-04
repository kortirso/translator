class UsersController < ApplicationController
    before_action :check_signed, only: :index
    before_action :find_user, only: :show

    def index
        
    end

    def show

    end

    private

    def check_signed
        redirect_to current_user if user_signed_in?
    end

    def find_user
        @user = User.find_by(id: params[:id])
        render_not_found if !user_signed_in? || @user.nil? || @user != current_user
    end
end
