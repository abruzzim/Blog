class User < ActiveRecord::Base
  # Many Posts reference User.
  has_many :posts
end