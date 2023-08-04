class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :large, resize_to_fill: [100, 100]
    attachable.variant :small, resize_to_fill: [50, 50]
    attachable.variant :tiny, resize_to_fill: [25, 25]
  end

  has_secure_password validations: false

  has_many :messages
  has_many :posts
  has_many :topics

  def has_password?
    password_digest?
  end
end
