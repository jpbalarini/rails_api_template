module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_filter :verify_authenticity_token, if: :json_request?
      skip_before_filter :verify_signed_out_user, only: :destroy

      # POST /resource/sign_in
      def create
        resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
        sign_in_and_redirect(resource_name, resource)
      end

      def sign_in_and_redirect(resource_or_scope, resource = nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        resource ||= resource_or_scope
        sign_in(scope, resource) unless warden.user(scope) == resource
        render json: { success: true, token: resource.authentication_token, email: resource.email }
      end

      # DELETE /resource/sign_out
      def destroy
        if current_user.present?
          # expire auth token
          current_user.invalidate_token
          render json: { message: ['Token was expired'] },  success: true, status: :ok
        else
          render json: { success: false, errors: ['You need to provide a Token and email'] }, status: :bad_request
        end
      end

      def failure
        render json: { success: false, errors: ['Login failed.'] }, status: :bad_request
      end

      protected

      def json_request?
        request.format.json?
      end
    end
  end
end
