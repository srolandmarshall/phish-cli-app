require_relative '../config/environment.rb'

class Scraper
  TOURS_PAGE ||= "http://phish.net/tour"
  SONGS_PAGE ||= "http://phish.net/song/?"
  SHOWS_PAGE ||= "http://phish.net/setlists/?"

  def scrape_tours
    puts "LOADING TOURS..."
    page = Nokogiri::HTML(open(TOURS_PAGE))
    cells = page.css("table").first.css("td")
    i=0
    while i < cells.length
      name = cells[i].text
      link = cells[i].css("a").first["href"]
      year = cells[i+1].text
      shows = cells[i+2].text.split(" ")[0].to_i
      Tour.new(name,link,year,shows)
      i+=3
    end
    puts "TOURS LOADED."
  end

  def self.scrape_tour(tour)
    page = Nokogiri::HTML(open(tour.link))
    links = page.css("div.tpcmainbox").css("a")
    links.each do |link|
      scrape_show(Nokogiri::HTML(open("http://phish.net#{link["href"]}")))
    end
    tour
  end


  def scrape_songs
    puts "LOADING SONGS..."
    page = Nokogiri::HTML(open(SONGS_PAGE))
    cells = page.css("td")
    i=0
    while i < cells.length
      if cells[i+2].text.to_i != 0
        name = cells[i].text
        link = cells[i].css("a")[0]["href"]
        original_artist = cells[i+1].text
        times =  cells[i+2].text.to_i
        debut = cells[i+3].text
        last = cells[i+4].text
        gap = cells[i+5].text.to_i
        Song.new(name,link,original_artist,times,debut,last,gap) # replace with find or create later
      end
      i+=6
    end
    puts "SONGS LOADED."
  end

  def self.get_setlist(page)
    soundcheck = ""
    set1, set2, set3, set4, encore = [],[],[],[],[]
    setlist = Setlist.new(soundcheck, set1, set2, set3, set4, encore)
    page.css("div.setlist-body").css('p').each do |set|
      if set.css("i").text.include?("Soundcheck")
        setlist.soundcheck = set.text.strip
      else
        songs = []
        set.css("a").each do |song|
          songs << Song.find_by_name(song.text)
        end
        setlist.set1 = songs if set.css("span").text == "SET 1"
        setlist.set2 = songs if set.css("span").text == "SET 2"
        setlist.set3 = songs if set.css("span").text == "SET 3"
        setlist.set4 = songs if set.css("span").text == "SET 4"
        setlist.encore = songs if set.css("span").text == "ENCORE"
      end
    end
    setlist
  end

  def self.get_jams(page)
    jams = []
    page.css("div.tpcbox").css("div.box-body")[0].css("a").each do |jam|
      jams << Song.find_by_name(jam.text)
    end
    jams
  end

  def self.scrape_show(page)
    venue = page.css("div.setlist-venue").css(".hideover768").text
    location = page.css("div.setlist-location").text
    setlist = get_setlist(page)
    date = page.css("span.setlist-date").css("a")[1].text
    notes = page.css("div.setlist-notes").text
    rating = page.css("div.permalink-rating").text.split(" ")[3].split("/")[0].to_f
    jams = get_jams(page)
    tour = Tour.find_by_name(page.css("h4.bs-callout").css("a")[0].text)
    Show.new(tour, date, venue, location, setlist, notes, rating, jams)
    puts "Scraped #{Show.all.last.date}"
  end

  #date input should always be YYYY-MM-DD
  def get_date_page(date)
    Nokogiri::HTML(open("http://phish.net/setlists/d?#{date}"))

  end

  def scrape_shows

    Tour.all.each do |tour|
      links = []
      tour_page = Nokogiri::HTML(open(tour.link))
      tour_page.css("div.tpcmainbox").css("a").each {|link| links << link["href"] if link["href"] =~ /setlists\/phish/}
      links.each do |link|
        show_page = Nokogiri::HTML(open("http://phish.net#{link}"))
        tour.shows << scrape_show(show_page)
        puts "Scraped page #{tour.shows.last.date}"
      end
    end
    binding.pry
  end

  def initialize
    self.scrape_songs
    self.scrape_tours
  end

end
