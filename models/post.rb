class Post < ActiveRecord::Base
  # Post references User.
  belongs_to :user
end