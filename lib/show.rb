class Show

  attr_accessor :venue, :city, :day, :month, :year, :date, :num_sets, :setlist, :notes, :rating, :jams

  #setlist should be a hash with key value pairs of arrays of Songs.

  #other shows on this date??

  @@all = []

  def initialize(date="", day="", month="", year=1983, venue="", city="", setlist={}, notes="", rating=1.1, jams=[])
    @date = date
    @day = day
    @month = month
    @year = year
    @venue = venue
    @city = city
    @setlist = setlist
    @notes = notes
    @rating = rating
    @jams = jams
    @num_sets = setlist.length-1
  end


  def self.all
    @@all
  end



end
