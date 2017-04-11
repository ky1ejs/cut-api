class UserController < ApplicationController
  def get_current_user
    render json: device.user
  end

  def get_user
    render json: User.find_by(username: params[:username])
  end

  def find_user

  end

  def create_login
    u = device.user

    if u.is_full_user
      render status: 422
      return
    end

    u.username = params[:username]
    u.email = params[:email]
    u.hashed_password = params[:password]
    u.save!
    
    render json: u
  end

  def add_device_to_user
    u = User.find_by(email: params[:email])

    if u.hashed_password != params[:password] || u.id == device.user.id
      render status: 422
      return
    end

    old_user = device.user

    device.user = u
    device.save!

    old_user.destroy!

    render status: 200
  end

  def follow_user
    username = params[:username]

    if username == device.user.username
      render status: 422
      return
    end

    u = User.find_by(username: username)
    Follow.find_or_create_by(follower: device.user, following: u).save!
  end
end
