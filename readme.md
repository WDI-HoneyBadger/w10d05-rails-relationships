# Rails Relationships

## Learning Objectives
- Understand how to make migrations that reference other models
- Set up relationships in models using `belongs_to` and `has_many`
- Use ActiveRecord models to query and create related entities
- Learn how shallow routes support related models 


## Referenced Migrations

Lets say we have an app where we are storing information about music artists and their work. We can start by generating a model for an artist with:

```
rails g model Artist name:string genre:string
```

This will create an Artist model and a migration to add the table to our database. If we want to then add a table where we keep track of each artist's albums, we'll want to generate a new model for Albums. In the SQL world we learned about foreign keys and how they keep track of a primary key that the entry relates to. For example an Album can have an `artist_id` that references back to an artist. In rails we can add this reference when we generate the model:

```
rails g model Album name:string release_year:integer artist:references
```

This will create a migration that looks like:
```ruby
class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :release_year
      #this line will add our foreign key for artist_id
      t.references :artist, foreign_key: true 

      t.timestamps
    end
  end
end
```

## belongs_to

Generating that model will also create a model file that looks like:
```ruby
class Album < ApplicationRecord
  belongs_to :artist
end
```

A line is added that tells our model that there is a relationship to another table. This does a few things. 
1. It makes it so when we create an album, we need to specify an artist for it. 
```ruby
kesha = Artist.create({
  name: "Ke$ha",
  genre: "pop"
})

rainbow = Album.create({
  name: "Rainbow",
  release_year: 2017,
  artist: kesha # we need to specify an artist here or there will be errors!
})
```
2. It allows us to access our artist from our album
```ruby
rainbow.artist # will give us kesha
```

## has_many

At this point, we may also want to be able to access all of the albums from an artist. To add these methods to our Artist, we need to edit our artist model:
```ruby
class Artist < ApplicationRecord
  has_many :albums
end
```

Now we can access albums from any artist.
```ruby
Artist.first.albums # will give us back all of the albums associated with the first artist
```

We can also create albums through our artist
```ruby
kesha = Artist.find_by({ name: "Ke$ha" })
kesha.albums.create({
  name: "Animal",
  release_year: 2010,
  artist: kesha
}) # will create the "Animal" album with the artist "Ke$ha"
```

## Rails relational routing 

Setting up routes can be challenging. There are a lot of ways to do so and there often isn't always a **"right way"**. Its always good to think about your application and what you need from it and go through your options. 

For example, for our music app we could:

#### 1. Have distinct seperate routes for artists and albums:

```ruby
Rails.application.routes.draw do
  resources :artists
  resources :albums
end
```
which would give us:


|method|route|result|
|------|-----|------|
|GET|/artists|get all artists|
|POST|/artists|create an artist|
|GET|/artists/:id|get an artist by id|
|PUT|/artists/:id|update an artist|
|DELETE|/artists/:id|delete an artist|
||||
|GET|/albums|get all albums|
|POST|/albums|create an album|
|GET|/albums/:id|get an album by id|
|PUT|/albums/:id|update an album|
|DELETE|/albums/:id|delete an album|

#### 2. Nest albums completely under artists:

```ruby
Rails.application.routes.draw do
  resources :artists do
    resources :albums
  end
end
```
which would give us:


|method|route|result|
|------|-----|-----|
|GET|/artists|get all artists|
|POST|/artists|create an artist|
|GET|/artists/:id|get an artist by id|
|PUT|/artists/:id|update an artist|
|DELETE|/artists/:id|delete an artist|
||||
|GET|/artists/:artist_id/albums|get albums by an artist|
|POST|/artists/:artist_id/albums|create an album belonging to an artist|
|GET|/artists/:artist_id/albums/:id|get an album by artist id and album id|
|PUT|/artists/:artist_id/albums/:id|update an album by artist id and album id|
|DELETE|/artists/:artist_id/albums/:id|delete an album by artist id and album id|

#### 3. Use what we call "shallow" routes for the albums
```ruby
Rails.application.routes.draw do
  resources :artists do
    resources :albums, shallow: true
  end
end
```
which would give us:


|method|route|result|
|------|-----|-----|
|GET|/artists|get all artists|
|POST|/artists|create an artist|
|GET|/artists/:id|get an artist by id|
|PUT|/artists/:id|update an artist|
|DELETE|/artists/:id|delete an artist|
||||
|GET|/artists/:artist_id/albums|get albums by an artist|
|POST|/artists/:artist_id/albums|create an album belonging to an artist|
|GET|/albums/:id|get an album by id|
|PUT|/albums/:id|update an album|
|DELETE|/albums/:id|delete an album|

The last one here is good because it stops our routes from getting too long. I like to do a bit of a mixture where I use shallow routes, but also add in an index for albums not scoped to artists. This way I have a route to see all of the albums, not just by artist.

```ruby
Rails.application.routes.draw do
  resources :artists do
    resources :albums, shallow: true
  end

  get "/albums", to: "albums#index"
end
```
which would give us:


|method|route|result|
|------|-----|-----|
|GET|/artists|get all artists|
|POST|/artists|create an artist|
|GET|/artists/:id|get an artist by id|
|PUT|/artists/:id|update an artist|
|DELETE|/artists/:id|delete an artist|
|||
|GET|/artists/:artist_id/albums|get albums by an artist|
|POST|/artists/:artist_id/albums|create an album belonging to an artist|
|GET|/albums/:id|get an album by id|
|PUT|/albums/:id|update an album|
|DELETE|/albums/:id|delete an album|
||||
|GET|/albums|get all albums|
