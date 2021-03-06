module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :configure_permitted_parameters, only: [:create]
      skip_before_filter :verify_authenticity_token, if: :json_request?

      def create
        build_resource(sign_up_params)
        resource_saved = resource.save
        if resource_saved
          save_success
          render json: { success: true, token: resource.authentication_token, email: resource.email }
        else
          save_fail
          render json: { success: false, error: resource.errors.to_json }, status: :bad_request
        end
      end

      protected

      def save_success
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
        else
          expire_data_after_sign_in!
        end
      end

      def save_fail
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        if @validatable
          @minimum_password_length = resource_class.password_length.min
        end
      end

      def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) \
          { |params| params.permit(:username, :email, :password, :password_confirmation, :invitation_token) }
      end

      def json_request?
        request.format.json?
      end
    end
  end
end
