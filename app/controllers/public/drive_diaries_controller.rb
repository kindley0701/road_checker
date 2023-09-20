class Public::DriveDiariesController < ApplicationController
  def new
    @diary = DriveDiary.new
  end

  def create
    #ファイルの取得
    file = params[:drive_diary][:file]
    ext_name = File.extname(file.path) #拡張子の取得

    #拡張子で分岐
    if ext_name == '.csv' # CSVの場合
      diary = DriveDiary.new(diary_params)
      diary.customer_id = current_customer.id
      diary.save
      CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true) do |row|
        #各行の処理：ヘッダーがある場合row["ヘッダーにあるカラム名(日本語可)"]で列が指定できる
        latitude = row["緯度"].to_f
        longitude = row["経度"].to_f
        DriveCoordinate.find_or_create_by(drive_diary_id: diary.id, latitude: latitude, longitude: longitude)
      end
    elsif ext_name == '.kml' #kmlの場合
      dom = REXML::Document.new(open(file.path))
      #日付の取得
      title = dom.elements['/kml/Document/name'] #nameタグ内に日付情報が存在
      date = title.text.split(' ')[3].to_date #文字列で取り出し，半角区切り4番目の文字列を取得→日付型に変換
      diary = DriveDiary.create(date: date, customer_id: current_customer.id) #日記データの登録

      dom.elements.each('/kml/Document/Placemark') do |placemark| #.elements.each(タグ指定)：探したタグが複数存在している場合に使う
        #各Placemarkタグに対する処理
        #以下Placemarkタグ内にPointタグとLineStringタグのどちらが存在するかによって分岐：座標データが点か線かで分岐
        point = placemark.elements['Point/coordinates'] #Placemarkタグ→Pointタグ→coordinatesタグの読込
        if point #読み込んだタグが存在していれば：Pointタグの場合
          coordinate = point.text.split(',') #カンマ区切りで配列に変換：座標情報を緯度と経度に分ける
          # 緯度経度の取り出し：string型からfloat型に変換
          latitude = coordinate[1].to_f
          longitude = coordinate[0].to_f
          DriveCoordinate.find_or_create_by(latitude: latitude, longitude: longitude, drive_diary_id: diary.id) #座標の登録
        else #LineStringタグの場合
          line = placemark.elements['LineString/coordinates'] #Placemarkタグ→LineStringタグ→coordinatesタグの読込
          points = line.text.split(" ") #半角スペース区切りで配列に変換：座標情報を線から点に変換
          points.each do |point| #配列を要素に分割
            #各点に分割して処理を実行
            coordinate = point.split(',') #カンマ区切りで配列に変換：座標情報を緯度と経度に分ける
            # 緯度経度の取り出し：string型からfloat型に変換
            latitude = coordinate[1].to_f
            longitude = coordinate[0].to_f
            DriveCoordinate.find_or_create_by(latitude: latitude, longitude: longitude, drive_diary_id: diary.id) #座標の登録
          end
        end
      end
    else #拡張子が合わない場合
      render :new
    end

    redirect_to drive_diary_path(diary.id)
  end

  def show
    @diary = DriveDiary.find(params[:id])
    @coords = @diary.drive_coordinates
  end

  def destroy
    DriveDiary.find(params[:id]).destroy
    redirect_to customer_path(current_customer.id)
  end

  private
  def diary_params
    params.require(:drive_diary).permit(:date)
  end

end
