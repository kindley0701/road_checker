class Road < ApplicationRecord
  
  has_many :kilo_posts, dependent: :destroy

end
