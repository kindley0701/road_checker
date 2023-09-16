class Road < ApplicationRecord
  
  has_many :kilo_posts, dependent: :destroy
  
  enum category: {national: 0, prefectural: 1}

end
