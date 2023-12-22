Rails.application.routes.draw do
  get 'cdn(/*path)' => 'files#index'
  get 'errors/not_found'
  root 'pages#index'
  post '/report', to: 'pages#log_report'
  get '/report/list', to: 'pages#report_list'
  get '*path', to: 'errors#not_found', via: :all
end
