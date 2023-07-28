class User < ApplicationRecord
  has_secure_password validations: false

  has_many :messages
  has_many :posts
  has_many :topics

  def has_password?
    password_digest?
  end
end
