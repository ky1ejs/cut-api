class FeedController < ApplicationController
  def index
    user = device.user
    watches = user.following.map(&:watch_list_records)
    watches = watches.flatten
    watches = watches.sort_by(&:created_at)
    render json: watches.as_json(include: :film)
  end
end
