Rails.application.routes.draw do

  get '/users/me', to: 'users#me', as: 'me'
  get '/users/password-reset', to: 'users#reset_password'
  patch '/users/password-reset', to: 'users#update_by_token'
  get '/users/missing_before_forms', to: 'users#missing_before_forms'
  get '/users/missing_after_forms', to: 'users#missing_after_forms'
  get '/events/:id/missing_forms', to: 'events#missing_forms'
  get '/events/:id/notify_before', to: 'events#remind_before'
  get '/events/:id/notify_after', to: 'events#remind_after'
  get '/events/:id/import_formdata', to:'formdata#import_data'

  resources :users do
    get '/resume', to: 'resumes#show'
    patch '/resume', to: 'resumes#update'
    get '/resume-download', to: 'resumes#download'
  end

  
  resources :users
  resources :events
  resources :companies
  resources :user_event_forms

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
