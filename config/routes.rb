Railsroot::Application.routes.draw do
  devise_for :users,
    path: 'api/v1/users/',
    controllers: { sessions: 'api/v1/sessions', registrations: 'api/v1/registrations', passwords: 'api/v1/passwords' }

  root 'api/v1/api#status'

  match '*all', to: 'application#cors_preflight_check', via: [:options]

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      resources :users, only: [:update] do
        collection do
          post :facebook_login
        end
      end
    end
  end
end
