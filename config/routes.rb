Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'sitemaps/:name/url', to: 'sitemaps#show_url_by_name'
      resources :sitemaps, only: [:index]
    end
  end
  get 'cdn(/*path)' => 'files#index'
  get 'errors/not_found'
  root 'pages#index'
  get '/index.aspx', to: 'pages#indexm'
  post '/report', to: 'pages#log_report'
  get '/report/list', to: 'pages#report_list'
  get '/database', to: 'game_database#index'
  get '/database/*content', to: 'game_database#content', format: false
  get '*path', to: 'errors#not_found', via: :all
end
