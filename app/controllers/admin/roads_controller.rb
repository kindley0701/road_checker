class Admin::RoadsController < ApplicationController
  def new
  end

  def create
    file = params[:file] #フォームからファイルを受け取る
    dom = REXML::Document.new(open(file.path))
  
    dom.each_element_with_text('2', 0, '/ksj:Dataset/ksj:Road/ksj:roadTypeCode') do |road_type_code|
        road_number = road_type_code.next_element.text.split('国道')[1].split('号線')[0].tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z').to_i
        national_road = Road.find_or_create_by(category: road_type_code.text.to_i, number: road_number)
          
        id = road_type_code.previous_element.attributes.get_attribute("xlink:href").to_s.split('#')[1]
          
        dom.elements['/ksj:Dataset'].each_element_with_attribute('gml:id', id, 0, 'gml:Curve') do |curve|
          line = curve.elements['gml:segments/gml:LineStringSegment/gml:posList']
          points = line.text.split(' ')
          point_count = points.length
          for i in 1..point_count/2
            latitude = points[2*(i-1)]
            longitude = points[2*i-1]
            KiloPost.find_or_create_by(road_id: national_road.id, latitude: latitude, longitude: longitude)
          end
        end  
      end
    
    # #CSV.foreach(ファイルのパス)で1行ずつ読み込む．オプション(encoding:文字コードの指定，headers:ファイル内にヘッダーがあるか)
    # CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true) do |row|
    #   #各行の処理：ヘッダーがある場合row["ヘッダーにあるカラム名(日本語可)"]で列が指定できる
    #   road = Road.find_or_create_by(number: row["路線"]) #find_or_create_by()で二重登録を防ぐ．
    #   latitude = row["緯度（度）"].to_f + row["緯度（分）"].to_f/60 + row["緯度（秒）"].to_f/3600
    #   longitude = row["経度（度）"].to_f + row["経度（分）"].to_f/60 + row["経度（秒）"].to_f/3600
    #   KiloPost.find_or_create_by(road_id: road.id, latitude: latitude, longitude: longitude)
    # end
    redirect_to admin_roads_path
  end

  def index
    @roads = Road.order(number: 'ASC')
  end

  def show
    @road = Road.find(params[:id])
    @kilo_posts = @road.kilo_posts
  end

  private

end
