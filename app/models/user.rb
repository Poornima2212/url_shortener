class User < ApplicationRecord
    encrypts :email
    has_many :urls
    validates :email, presence: true, uniqueness: true
end