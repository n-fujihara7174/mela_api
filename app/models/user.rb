class User < ApplicationRecord
    has_many :post
    has_many :like
    has_many :message
end
