# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
kesha = Artist.create({
  name: "Ke$ha",
  genre: "pop"
})

frank_sinatra = Artist.create({
  name: "Frank Sinatra",
  genre: "jazz"
})

caravan_palace = Artist.create({
  name: "Caravan Palace",
  genre: "electric-swing"
})

animal = Album.create({
  name: "Animal",
  release_year: 2010,
  artist: kesha
})


rainbow = Album.create({
  name: "Rainbow",
  release_year: 2017,
  artist: kesha
})

frankly_sentimental = Album.create({
  name: "Frankly Sentimental",
  release_year: 1949,
  artist: frank_sinatra
})

dedicated = Album.create({
  name: "Dedicated to You",
  release_year: 1950,
  artist: frank_sinatra
})

panic = Album.create({
  name: "Panic",
  release_year: 2012,
  artist: caravan_palace
})

🤖 = Album.create({
  name: "<|°_°|>",
  release_year: 2015,
  artist: caravan_palace
})