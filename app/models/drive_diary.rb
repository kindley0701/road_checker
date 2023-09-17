class DriveDiary < ApplicationRecord
  has_many :drive_coordinates, dependent: :destroy
  belongs_to :customer
end
