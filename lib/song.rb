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
      return song if song.name.downcase == name.downcase
    end
    nil
  end

  def know_more
    puts "\nWould you like to know more? Y/N"
    input = gets.chomp.upcase
    Song.scrape_song(self) if input == "Y" || input == "YES"
    know_more if input != "N" && input != "NO"
  end

  def display
    puts @name
    puts "Originally by: #{@original_artist}" if @original_artist != "Phish"
    puts "Times Played: #{@times_played}"
    puts "Debut Date: #{@debut_date}"
    puts "Last Played: #{@last_played}"
    puts "Shows since last played: #{@gap}"
    know_more
  end

end
