Rails.application.routes.draw do
  get "/" => "pages#home"
  get "/register" => "pages#register"
  get "/fitbit_callback" => "pages#fitbit_callback"
  get "/data" => "pages#data"
end
