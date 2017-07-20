class Show

  attr_accessor :venue, :city, :day, :month, :year, :date, :num_sets, :setlist, :notes, :rating, :jams

  #setlist should be a hash with key value pairs of arrays of Songs.

  #other shows on this date??

  @@all = []

  def self.all
    @@all
  end



end
