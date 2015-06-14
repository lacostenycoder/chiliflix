class Chill < ActiveRecord::Base

  def get_movie(genre)

    lookup_genre = Tmdb::Genre.list["genres"].select{|g| g["name"].downcase == genre.downcase}.first
    top = Tmdb::Movie.top_rated
    found = top.select{|e| e["genre_ids"].include? lookup_genre["id"]} # && e["release_date"].to_datetime < Time.now - 90.days}
    movie = nil
    results = []
    unless movie
      movies = Tmdb::Genre.find(genre)
      current_page = 1
      while results.size < 10
        page = current_page > 1 ? movies.get_page(current_page) : movies
        page.results.each do |m|
          results << m if m["vote_average"] >= 8.0 && m["release_date"].to_datetime
        end
        current_page += 1
      end
    end
    movie = results.sample if results.present?
    unless movie
      movie = found.sample if found.present?
    end
    movie
  end

  def select_genre
    time = Time.current.strftime("%H").to_i
    case time
    when 0..4
      ["comedy", "Drama", "Adventure"].sample
    when 5..8
      ["Science Fiction", "Horror", "Thriller"].sample
    when 9..12
      ["Music", "Family", "History"].sample
    when 13..16
      ["War","Western","Mystery","Romance"].sample
    when 17..20
      ["Family", "Foreign", "Comedy", "Crime"].sample
    when 21..23
      ["Action", "Adventure", "Romance", "Documentary", "Comedy", "Drama"].sample
    end
  end
end
