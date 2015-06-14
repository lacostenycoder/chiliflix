class ChillsController < ApplicationController

  after_action :post_chill, on: [:index]

  def index
    puts _process_action_callbacks.map(&:filter)
  end

  def new
    @chill = Chill.new
  end


  def create
    @chill = Chill.new
  end

  def chillout
    firebase = Firebase::Client.new(ENV['FIREBASE_URI'], ENV['FIREBASE_SECRET'])
    redirect_to root_path
  end

  private

  def post_chill
    firebase = Firebase::Client.new(ENV['FIREBASE_URI'], ENV['FIREBASE_SECRET'])
    chill = Chill.new
    genre = chill.select_genre
    movie = chill.get_movie(genre)
    firebase.push("chill", {:title => movie["title"], :movie => movie["overview"], :datetime => Time.now.to_s})
  end


end
