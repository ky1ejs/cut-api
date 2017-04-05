Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/v1' do
    scope '/films' do
      get '/' => 'film#index'
    end
    scope '/devices' do
      post '/' => 'device#register_device'
    end
  end
end
