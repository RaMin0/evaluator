Rails.application.routes.draw do
  namespace :api do
    resources :contacts, only: [:create]
    resources :users, param: :email, only: [] do
      member do
        get :resend_verify, action: :resend_verify
        get :reset_password, action: :reset_password
      end
    end
    resources :users, except: [:new] do
      member do
        put :confirm_reset, action: :confirm_reset
        put :verify, action: :verify
      end
    end
    resources :teams, only: [:create]
    resources :courses, except: [:new] do
      member do
        post :registration, action: :register
        delete :registration, action: :unregister
      end
      resources :projects, shallow: true, except: [:new] do
        resources :results, shallow: true, only: [:index, :show]
        resources :submissions, shallow: true, except: [:destroy, :new, :update] do
          member do
            get :download, action: :download
          end
        end
        resources :test_suites, shallow: true, except: [:new, :update] do
          member do
            get :download, action: :download
          end
        end
      end
    end
    resources :tokens, only: [:create]
    resources :configurations, only: [:index]
    resource :project_bundle, only: [:create] do
      member do
        get :download, action: :download
      end
    end
  end
end
