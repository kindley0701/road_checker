class DriveDiary < ApplicationRecord
  has_many :drive_coordinates, dependent: :destroy
end
