namespace :monitor do
  desc 'MONITOR CLOUD'
  task :chills => :environment do

    require 'pry'
    require 'uri'
    firebase = Firebase::Client.new(ENV['FIREBASE_URI'], ENV['FIREBASE_SECRET'])
    chills = firebase.get("chill")
    fridge = firebase.get("open")
    open_count = fridge.body.nil? ? 0 : fridge.body.to_hash.count
    fridge = 0 if fridge.nil?
    chill_tracker = Chill.where(:description => "track").first_or_initialize
    chill_count = chills.body.to_hash.count

    if chill_count > chill_tracker.chills_count
      chill_tracker.chills_count = chill_count
    end

    if open_count && open_count > chill_tracker.fridge_count
      chill_tracker.fridge_count = fridge_count
    end

    chill_tracker.save if chill_tracker.changed?
    
    if chill_tracker.changed
      firebase = Firebase::Client.new(ENV['FIREBASE_URI'], ENV['FIREBASE_SECRET'])
      chill = Chill.new
      genre = chill.select_genre
      movie = chill.get_movie(genre)
      firebase.push("chill", {:title => movie["title"], :movie => movie["overview"], :datetime => Time.now.to_s})
    end

  end

end
