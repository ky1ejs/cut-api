class UserController < ApiController
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
    u.password = params[:password]
    u.save!

    render json: u
  end

  def follow_unfollow_user
    username = params[:username]

    if username == device.user.username
      render status: 422
      return
    end

    user = User.find_by(username: username)
    if request.delete?
      device.user.following.delete(user)
    elsif request.post?
      f = Follow.new
      f.follower = device.user
      f.following = user
      f.save!

      n = NewFollowerNotification.new
      n.user = user
      n.follow = f
      n.save!
    end

    device.user.save!

    render status: 200
  end

  def login
    if device.user.is_full_user
      render status: 422 # user is already logged in on this device
      return
    end

    new_user =    User.find_by(username: params[:email_or_username])
    new_user ||=  User.find_by(email: params[:email_or_username])

    if new_user&.check_password(params[:password]) == true
      old_user = device.user

      old_user.watch_list_records.each do |w|
        if new_user.watch_list.map(&:id).include? w.film.id
          next
        end
        w.user = new_user
        w.save!
      end

      device.user = new_user
      device.save!

      old_user.destroy!

      render json: new_user
    else
      render status: 422
    end
  end

  def logout
    if !device.user.is_full_user
      render status: 422
      return
    end

    device.user = User.new
    device.save!

    render json: device.user
  end

  def get_qr_code
    if !device.user.is_full_user
      render status: 422 # user is already logged in on this device
      return
    end

    qr_code = RQRCode::QRCode.new(device.user.username)
    png = qr_code.as_png size: 500, border_modules: 0, module_px_size: 0
    render text: png.to_s, type: 'image/png'
  end
end
