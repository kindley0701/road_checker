class Road < ApplicationRecord
  
  has_many :kilo_posts, dependent: :destroy
  
  enum category: {national: 2, prefectural: 3}

end
