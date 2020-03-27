Rails.application.routes.draw do
  scope :api, default: { format: :json } do
    get "/get", to: "fonts#get"
  end 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
