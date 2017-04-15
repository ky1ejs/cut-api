require 'httparty'
require 'digest/md5'
require 'bcrypt'

class User < ApplicationRecord
  has_many :devices
  has_many :watch_list_records, foreign_key: :user_id, class_name: "WantToWatch"
  has_many :watch_list, through: :watch_list_records, source: :film
  has_many :follower_records, foreign_key: :following_id, class_name: "Follow"
  has_many :following_records, foreign_key: :follower_id, class_name: "Follow"
  has_many :followers, through: :follower_records
  has_many :following, through: :following_records

  def password_is_set
    !self.password.nil? || (!self.hashed_password.nil? && !self.salt.nil?)
  end

  def full_user_fields
    [self.email, password_is_set ? "password" : nil, self.username]
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

  def check_password(password)
    hashed_password = BCrypt::Engine.hash_secret(password, self.salt)
    return self.hashed_password == hashed_password
  end

  attr_accessor :password

  before_validation :set_initial_last_seen, on: :create
  before_save :encrypt_password
  after_save :clear_password

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  validate :validate_full_user
  validates :username, :presence => true, :allow_nil => true, :uniqueness => true
  validates :password, :presence => true, :allow_nil => true
  validates :email, :presence => true, :allow_nil => true, :uniqueness => true, :format => EMAIL_REGEX

  protected

  def set_initial_last_seen
    self.last_seen ||= Time.now
  end

  def validate_full_user
    error_message = "Mandatory full user fields not complete #{full_user_fields}"
    any_fields_not_nil = full_user_fields.any? { |e| !e.nil?  }
    errors.add :base, error_message if any_fields_not_nil && !is_full_user
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  # Protecting access to hashed_password and salt
  def hashed_password
    self[:hashed_password]
  end

  def hashed_password=(hash)
    write_attribute :hashed_password, hash
  end

  def salt
    self[:salt]
  end

  def salt=(salt)
    write_attribute :salt, salt
  end
end
