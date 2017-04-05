class User < ApplicationRecord
  has_many :devices
  has_many :want_to_watch
end
