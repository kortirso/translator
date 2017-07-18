module Api
    module V1
        class UsersController < Api::V1::BaseController
            skip_before_action :authenticate, only: %i[create access_token]
            before_action :find_user_by_credentials, only: %i[access_token]
            before_action :find_user_by_id, only: %i[update destroy]
            before_action :check_owner, only: %i[update destroy]

            def me
                render json: @user, status: 200
            end

            def access_token
                @user.update_token
                render json: @user, status: 201
            end

            def create
                user = User.new(user_params)
                if user.save
                    user.update_token
                    render json: user, status: 201
                else
                    render json: {error: 'User creation error'}, status: 409
                end
            end

            def update
                if @user.update(user_params)
                    render json: @user, status: 200
                else
                    render json: {error: 'User updating error'}, status: 409
                end
            end

            def destroy
                @user.destroy
                render json: {success: 'User destroyed successfully'}, status: 200
            end

            private

            def user_params
                params.require(:user).permit(:username, :email, :password, :password_confirmation)
            end

            def find_user_by_credentials
                @user = User.find_by(email: params[:email], password: params[:password])
                render json: {error: 'Unauthorized'}, status: 401 if @user.nil?
            end

            def find_user_by_id
                @resourse = User.find_by(id: params[:id])
                render json: {error: 'User not found'}, status: 404 if @resourse.nil?
            end

            def check_owner
                render json: {error: 'You cant modify another user'}, status: 403 if @user != @resourse
            end
        end
    end
end
