require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash

get '/songs/new' do
    erb :'/songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb:'/songs/show'
  end

post '/songs' do
  binding.pry
@song = Song.create(name: params["Name"])
@song.artist = Artist.find_or_create_by(name: params["Artist Name"])
if params["genres"]
  genre = Genre.find_by(id: params["genres"][0].to_i)
  @song.genres << genre
end
@song.save
flash[:message] = "Successfully created song."
redirect("/songs/#{@song.slug}")
end


get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.update(params[:song])
    @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
    @song.genre_ids = params[:genres]
    @song.save

    flash[:message] = "Successfully updated song."
    redirect("/songs/#{@song.slug}")
  end

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

end
