require_relative '../config/environment.rb'

class Setlist

  @@all = []
  attr_accessor :set1, :set2, :set3, :set4, :encore, :show, :soundcheck

  def initialize(soundcheck, set1, set2, set3, set4, encore)
    @set1 = set1
    @set2 = set2
    @set3 = set3
    @set4 = set4
    @encore = encore
    @@all << self
    @soundcheck = soundcheck
  end

  def song_names(set)
    names = []
    set.each do |song|
      names << song.name
    end
    names.join(', ')
  end

  def display
    puts "Soundcheck: #{@soundcheck} \n\n" if @soundcheck != ""
    puts "SET 1: #{song_names(@set1)} \n\n" if @set1 != []
    puts "SET 2: #{song_names(@set2)} \n\n" if @set2 != []
    puts "SET 3: #{song_names(@set3)} \n\n" if @set3 != []
    puts "SET 4: #{song_names(@set4)} \n\n" if @set4 != []
    puts "ENCORE: #{song_names(@encore)} \n\n" if @encore != []
  end

  def self.all
    @@all
  end

end
