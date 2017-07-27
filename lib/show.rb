require_relative '../config/environment.rb'
class Show

  attr_accessor :venue, :city, :date, :notes, :rating, :jams, :tour

  #date should maybe be an object with day, month, year, name if I want to do other shows on this date??

  @@all = []

  def initialize(tour=Tour.new, date="", venue="", city="", setlist=Setlist.new, notes="", rating=1.1, jams=[])
    @date = date
    @venue = venue
    @city = city
    @setlist = setlist
    @notes = notes
    @rating = rating
    @jams = jams
    @@all << self
  end


  def self.all
    @@all
  end

  def self.find_by_date(date)
    self.all.each do |show|
      return show if show.date == date
    end
    nil
  end

  def self.find_by_name(name)
    self.all.each do |show|
      return show if show.name == name
    end
    nil
  end

  def setlist=(setlist)
    @setlist = setlist
    setlist.show = self
  end

  def setlist(setlist)
    Setlist.display(setlist)
  end

end
