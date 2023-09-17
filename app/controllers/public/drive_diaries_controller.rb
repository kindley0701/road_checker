class Public::DriveDiariesController < ApplicationController
  def new
    @diary = DriveDiary.new
  end

  def create
    file = params[:drive_diary][:file]
    diary = DriveDiary.new(diary_params)
    diary.customer_id = current_customer.id
    diary.save
    CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true) do |row|
      #各行の処理：ヘッダーがある場合row["ヘッダーにあるカラム名(日本語可)"]で列が指定できる
      latitude = row["緯度"].to_f
      longitude = row["経度"].to_f
      DriveCoordinate.find_or_create_by(drive_diary_id: diary.id, latitude: latitude, longitude: longitude)
    end
    redirect_to drive_diary_path(diary.id)
  end

  def show
    @diary = DriveDiary.find(params[:id])
    @coords = @diary.drive_coordinates
  end

  private
  def diary_params
    params.require(:drive_diary).permit(:date)
  end

end
