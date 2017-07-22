# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def create_user(username)
  u = User.create(username: username, password: 'Password123', email: "#{username}@cut.watch")
  u.save!
  u
end

kyle = create_user('kylejm')
denny = create_user('denny')
arun = create_user('arun')
fabio = create_user('fabio')

fabio.followers = [kyle, denny, arun]
arun.followers = [denny, fabio]
denny.followers = [fabio]
kyle.followers = [fabio]

spider_man = Film.create(title: "Spider-Man: Homecoming",
                        theater_release_date: Date.new + 5.days,
                        synopsis: "A young Peter Parker/Spider-Man (Tom Holland), who...")
spider_man.save!

inception = Film.create(title: "Inception",
                        theater_release_date: Date.new + 5.days,
                        synopsis: "Pretty much the best film ever")
inception.save!

watch = [
  Watch.create(user: kyle, film: inception, rating: 5),
  Watch.create(user: kyle, film: spider_man, rating: 4.0),

  Watch.create(user: denny, film: spider_man),
  Watch.create(user: denny, film: inception),

  Watch.create(user: fabio, film: spider_man, rating: 4.5),
  Watch.create(user: fabio, film: inception, rating: 4.0),

  Watch.create(user: arun, film: spider_man),
  Watch.create(user: arun, film: inception, rating: 4.0)
]
watch.each { |e| e.save! }
