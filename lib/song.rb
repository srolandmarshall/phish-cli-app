require_relative '../config/environment.rb'
class Song

  @@all = []
  attr_accessor :name, :link, :original_artist, :times_played, :debut_date, :last_played, :gap, :appears_on, :aka, :rec_ver, :history, :lyrics, :musandlyr, :vocals, :original_album

  def initialize(name="",link="",original_artist="",times_played=0,debut="", last="", gap=0)
    @name = name
    @link = link
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
    if input == "Y" || input == "YES"
      self.display_exp
    end
    know_more if input != "N" && input != "NO"
  end

  def display
    puts "\n"
    puts @name
    puts "Originally by: #{@original_artist}" if @original_artist != "Phish"
    puts "Also known as: #{@aka}" if @aka
    puts "Times Played: #{@times_played}"
    puts "Debut Date: #{@debut_date}"
    puts "Last Played: #{@last_played}"
    puts "Shows since last played: #{@gap}"
    know_more
  end

  def display_exp
    puts "Original album: #{@original_album}" if @original_album
    puts "Appears on: #{@appears_on}" if @appears_on
    puts "Recommended versions: #{@rec_ver}" if @rec_ver
    puts "Music and Lyrics by: #{@musandlyr}" if @musandlyr
    puts "Vocals by: #{@vocals}" if @vocals
  end

  def display_history
    puts @history
  end

  def display_lyrics
    puts @lyrics
  end

end
