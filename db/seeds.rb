# Nasflix Demo Data Seeder
# This file is used by the "Load Demo Data" button in Admin Settings.
# It does NOT create users — onboarding handles admin creation.

puts "Seeding demo data..."

# Create demo users (non-admin)
parent1 = User.find_or_create_by!(email: "john@nasflix.com") do |u|
  u.name = "John (Parent)"
  u.password = "password"
  u.role = "parent"
end

parent2 = User.find_or_create_by!(email: "sarah@nasflix.com") do |u|
  u.name = "Sarah (Parent)"
  u.password = "password"
  u.role = "parent"
end

child1 = User.find_or_create_by!(email: "leo@nasflix.com") do |u|
  u.name = "Leo (Child)"
  u.password = "password"
  u.role = "child"
end

child2 = User.find_or_create_by!(email: "mia@nasflix.com") do |u|
  u.name = "Mia (Child)"
  u.password = "password"
  u.role = "child"
end

# Create Movies
movies = []
[
  { title: "The Shawshank Redemption", description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", genre: "Drama", year: 1994, director: "Frank Darabont" },
  { title: "Inception", description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.", genre: "Sci-Fi", year: 2010, director: "Christopher Nolan" },
  { title: "The Dark Knight", description: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests.", genre: "Action", year: 2008, director: "Christopher Nolan" },
  { title: "Pulp Fiction", description: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.", genre: "Thriller", year: 1994, director: "Quentin Tarantino" },
  { title: "Spirited Away", description: "During her family's move to the suburbs, a sullen 10-year-old girl wanders into a world ruled by gods, witches, and spirits.", genre: "Animation", year: 2001, director: "Hayao Miyazaki" },
  { title: "Interstellar", description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.", genre: "Sci-Fi", year: 2014, director: "Christopher Nolan" }
].each do |attrs|
  movie = Movie.find_or_initialize_by(title: attrs[:title])
  movie.assign_attributes(attrs)

  unless movie.video.attached?
    video_path = Rails.root.join('db', 'sample_video.mp4')
    movie.video.attach(io: File.open(video_path), filename: 'sample.mp4', content_type: 'video/mp4') if File.exist?(video_path)
  end

  unless movie.thumbnail.attached?
    thumb_path = Rails.root.join('db', 'sample_thumb.jpg')
    movie.thumbnail.attach(io: File.open(thumb_path), filename: 'sample.jpg', content_type: 'image/jpeg') if File.exist?(thumb_path)
  end

  movie.save!
  movies << movie
end

# Create Reviews
[
  { movie: movies[0], author: "Martin", content: "An absolute masterpiece. The storytelling is phenomenal.", rating: 5 },
  { movie: movies[0], author: "Jana", content: "One of the best movies ever made.", rating: 5 },
  { movie: movies[1], author: "Anna", content: "Mind-bending plot that keeps you thinking for days.", rating: 5 },
  { movie: movies[1], author: "Tomáš", content: "Confusing at first but rewarding on rewatch.", rating: 4 },
  { movie: movies[2], author: "Lukáš", content: "Heath Ledger's Joker is legendary.", rating: 5 },
  { movie: movies[3], author: "Karel", content: "Tarantino at his best. The dialogue is incredible.", rating: 5 },
  { movie: movies[4], author: "Hana", content: "Beautiful animation and a deeply touching story.", rating: 5 },
  { movie: movies[5], author: "Ondřej", content: "Visually spectacular. The science is fascinating.", rating: 4 }
].each do |attrs|
  Review.find_or_create_by!(movie: attrs[:movie], author: attrs[:author]) do |r|
    r.assign_attributes(attrs)
  end
end

# Create Watchlist Entries
WatchlistEntry.find_or_create_by!(user: parent1, movie: movies[0], status: "completed") do |w|
  w.start_date = Date.new(2025, 1, 10)
  w.end_date = Date.new(2025, 1, 10)
  w.notes = "Finally watched this classic"
end

WatchlistEntry.find_or_create_by!(user: parent1, movie: movies[4], status: "watching") do |w|
  w.start_date = Date.new(2025, 3, 1)
  w.notes = "Watching with subtitles"
end

# Create Movie Nights
host = User.find_by(role: "admin") || parent1
night1 = MovieNight.find_or_create_by!(movie: movies[1], host: host) do |mn|
  mn.scheduled_at = 3.days.from_now.change(hour: 20)
  mn.notes = "Pizza provided, bring drinks!"
end

night2 = MovieNight.find_or_create_by!(movie: movies[4], host: parent2) do |mn|
  mn.scheduled_at = 5.days.from_now.change(hour: 18)
  mn.notes = "Family viewing night"
end

# Create Invitations
Invitation.find_or_create_by!(movie_night: night1, user: parent2) do |i|
  i.status = "accepted"
end

Invitation.find_or_create_by!(movie_night: night2, user: child1) do |i|
  i.status = "accepted"
end

Invitation.find_or_create_by!(movie_night: night2, user: child2) do |i|
  i.status = "pending"
end

puts "Demo data loaded! #{Movie.count} movies, #{Review.count} reviews, #{User.count} users, #{MovieNight.count} movie nights."
