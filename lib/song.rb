require_relative '../config/environment.rb'
class Song

  @@all = []
  attr_accessor :name, :original_artist, :times_played, :debut_date, :last_played, :gap

  def initialize(name="",original_artist="",times_played=0,debut="", last="", gap=0)
    @name = name
    @original_artist = original_artist
    @times_played = times_played
    @debut_date = debut
    @last_played = last
    @gap = gap
  end

  def self.all
    @@all
  end


end
