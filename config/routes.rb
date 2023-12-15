Rails.application.routes.draw do
  root 'pages#index'
  post '/report', to: 'pages#log_report'
  get '/report/list', to: 'pages#report_list'
end
