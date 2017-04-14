Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/v1' do
    scope '/films' do
      get '/' => 'film#index'
    end
    scope '/watch-list' do
      get '/' => 'watch_list#index'
      post '/' => 'watch_list#add_film_to_watch_list'
    end
    scope '/users' do
      get '/' => 'user#get_current_user'
      scope '/:username' do
        get     '/'  => 'user#get_user'
        post    '/' => 'user#follow_unfollow_user'
        delete  '/' => 'user#follow_unfollow_user'
      end
      post '/' => 'user#create_login'
      scope '/devices' do
        post '/' => 'user#add_device_to_user'
      end
    end
    scope '/search' do
      get '/' => 'search#search'
    end
  end
end
