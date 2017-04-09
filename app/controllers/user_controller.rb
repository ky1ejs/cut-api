class UserController < ApplicationController
  def get_current_user
    render json: device.user
  end

  def find_user

  end

  def create_login
    u = device.user

    if u.can_login
      render status: 422
      return
    end

    u.username = params[:username]
    u.email = params[:email]
    u.hashed_password = params[:password]
    u.save!
    render status: 200
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
end
