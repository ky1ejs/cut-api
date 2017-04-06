Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/v1' do
    scope '/films' do
      get '/' => 'film#index'
    end
    scope '/devices' do
      post '/' => 'device#register_device'
    end
    scope '/watch-list' do
      get '/' => 'watch_list#index'
      post '/' => 'watch_list#add_film_to_watch_list'
    end
  end
end
