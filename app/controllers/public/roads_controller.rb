class Public::RoadsController < ApplicationController
  def show
    @road = Road.find(params[:id])
    @kilo_posts = @road.kilo_posts.limit(50)
  end
end
