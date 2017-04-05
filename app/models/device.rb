class Device < ApplicationRecord
  enum type: [ :ios, :android ]
  belongs_to :user
end
