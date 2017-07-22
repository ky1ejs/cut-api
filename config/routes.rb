Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope '/v1' do

    scope '/devices' do
      scope '/token' do
        post '/' => 'device#set_push_token'
        delete '/' => 'device#remove_push_token'
      end
    end

    scope '/films' do
      get '/' => 'film#index'
      scope '/:film_id' do
        post '/rate' => 'rating#rate_film'
      end
    end

    scope '/ratings' do
      get '/' => 'rating#index'
      post '/' => 'rating#rate_film'
      post '/' => 'rating#delete_rating'
    end

    scope '/search' do
      get '/' => 'search#search'
    end

    scope '/users' do
      get '/' => 'user#get_current_user'
      scope '/:username' do
        get     '/'  => 'user#get_user'
        post    '/' => 'user#follow_unfollow_user'
        delete  '/' => 'user#follow_unfollow_user'

        scope '/login' do
          post '/' => 'user#login'
        end
      end
      post '/' => 'user#create_login'
      scope '/devices' do
        post '/' => 'user#add_device_to_user'
      end
    end

    scope '/watch-list' do
      get '/' => 'want_to_watch#index'
      post '/' => 'want_to_watch#add_film_to_watch_list'
      delete '/' => 'want_to_watch#delete_film_from_watch_list'
    end

    scope '/feed' do
      get '/' => 'feed#index'
    end

  end

end
