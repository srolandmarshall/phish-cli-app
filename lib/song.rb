require_relative '../config/environment.rb'
class Song

  @@all = []
  attr_accessor :name, :link, :original_artist, :times_played, :debut_date, :last_played, :gap

  def initialize(name="",link="",original_artist="",times_played=0,debut="", last="", gap=0)
    @name = name
    @original_artist = original_artist
    @times_played = times_played
    @debut_date = debut # later, turn this into a Show using Find method
    @last_played = last # later, turn this into a Show using Find method
    @gap = gap
    @@all << self
  end

  def self.all
    @@all
  end

  def self.find_by_name(name)
    self.all.each do |song|
      return song if song.name == name
    end
    nil
  end

end
