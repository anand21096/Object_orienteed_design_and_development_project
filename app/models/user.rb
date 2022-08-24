class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true
  validates :email_id, presence: true, uniqueness: true

end
