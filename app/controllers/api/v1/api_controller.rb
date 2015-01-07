module Api
  module V1
    class ApiController < ApplicationController
      # require 'permissions_helper'

      respond_to :json

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActionController::RoutingError, with: :render_not_found
      rescue_from ActionController::UnknownController, with: :render_not_found
      rescue_from AbstractController::ActionNotFound, with: :render_not_found
      rescue_from PermissionsHelper::ForbiddenAccess, with: :render_forbidden_access

      def status
        render json: { online: true }
      end

      protected

      def render_forbidden_access(exception)
        logger.info(exception) # for logging
        render json: { error: 'Not Authorized' }, status: 403
      end

      def render_not_found(exception)
        logger.info(exception) # for logging
        render json: { success: false, error: exception.message }, status: 404
      end

      def process_errors(errors)
        if errors.blank?
          render json: { success: true }
        else
          render json: { success: false, error: errors }, status: :bad_request
        end
      end
    end
  end
end
