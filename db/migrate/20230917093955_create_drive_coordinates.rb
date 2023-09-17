class CreateDriveCoordinates < ActiveRecord::Migration[6.1]
  def change
    create_table :drive_coordinates do |t|
      t.float :latitude
      t.float :longitude
      t.integer :drive_diary_id
      t.timestamps
    end
  end
end
