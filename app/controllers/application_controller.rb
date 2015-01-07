class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: :json_request?
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_action :authenticate_user_token, unless: :non_authenticable_methods
  before_action :cors_set_access_control_headers

  layout false
  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    render json: { success: false, errors: ["You can't access this site"] }, status: :unauthorized
  end

  rescue_from ActionController::ParameterMissing do
    render json: { error: 'Parameter Missing' }, status: 400
  end

  rescue_from Exception, with: :render_error

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers = request.headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-User-Token'
      headers['Access-Control-Allow-Headers'] += ', X-User-Email, X-User-Facebook'
      headers['Access-Control-Max-Age'] = '1728000'
      render text: '', content_type: 'text/plain'
    end
  end

  protected

  def cors_set_access_control_headers
    headers = response.headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Headers'] += ', X-User-Token, X-User-Email, X-User-Facebook'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def render_error(exception)
    logger.info(exception) # for logging
    render json: { error: 'Internal server error' }, status: 500
  end

  def authenticate_user_token
    if current_user.blank?
      render json: { success: false, errors: ['You need to provide a valid token and email/fb'] }, status: :unauthorized
    end
  end

  def non_authenticable_methods
    request.method == 'OPTIONS' ||
    non_authenticable_devise_methods ||
    non_authenticable_api_methods ||
    (controller_name == 'users' && (action_name == 'facebook_login'))
  end

  def non_authenticable_api_methods
    controller_name == 'api' && action_name == 'status'
  end

  def non_authenticable_devise_methods
    non_authenticable_sessions || non_authenticable_registrations || non_authenticable_passwords
  end

  def non_authenticable_sessions
    devise_controller? && controller_name == 'sessions' &&
    (action_name == 'create' || action_name == 'failure')
  end

  def non_authenticable_registrations
    (devise_controller? && controller_name == 'registrations' && action_name == 'create')
  end

  def non_authenticable_passwords
    (devise_controller? && controller_name == 'passwords' && (action_name == 'create' || action_name == 'update'))
  end

  def json_request?
    request.format.json?
  end
end
