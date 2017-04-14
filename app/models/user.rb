require 'httparty'
require 'digest/md5'

class User < ApplicationRecord
  has_many :devices
  has_many :watch_list_records, foreign_key: :user_id, class_name: "WantToWatch"
  has_many :watch_list, through: :watch_list_records, source: :film
  has_many :follower_records, foreign_key: :following_id, class_name: "Follow"
  has_many :following_records, foreign_key: :follower_id, class_name: "Follow"
  has_many :followers, through: :follower_records
  has_many :following, through: :following_records

  def full_user_fields
    [self.email, self.hashed_password, self.username]
  end

  def is_full_user
    full_user_fields.all? { |e| !e.nil?  }
  end

  def as_json(options = {})
    json = super(options)

    if !self.email.nil?
      gravatar = "https://www.gravatar.com/avatar/"
      email_hash = Digest::MD5.hexdigest(self.email)
      query = '?d=404'
      profile_image_url = "#{gravatar}#{email_hash}#{query}"
      response = HTTParty.get profile_image_url
      json['profile_image'] = profile_image_url if response.code == 200
    end


    json['is_full_user'] = is_full_user
    json
  end

  before_validation :set_initial_last_seen, on: :create
  validate :validate_full_user

  protected

  def set_initial_last_seen
    self.last_seen ||= Time.now
  end

  def validate_full_user
    error_message = 'If email, username or hashed_password is set, they must all be set'
    any_fields_not_nil = full_user_fields.any? { |e| !e.nil?  }
    errors.add :base, error_message if any_fields_not_nil && !is_full_user
  end
end
