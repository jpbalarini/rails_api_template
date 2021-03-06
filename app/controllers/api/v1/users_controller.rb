module Api
  module V1
    class UsersController < Api::V1::ApiController
      # PUT /api/v1/users/:id
      def update
        if current_user.update(user_params)
          render json: { success: true }
        else
          render json: { success: false, error: current_user.errors.to_json }, status: :bad_request
        end
      end

      # POST /api/v1/users/facebook_login
      def facebook_login
        user_params
        @user = User.find_or_create_by_fb(params[:user])
      end

      private

      def render_bad_request
        render json: { success: false }, status: :bad_request
      end

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :facebook_id, :email,
          :welcome_screen, :how_to_trade, :notifications)
      end
    end
  end
end
