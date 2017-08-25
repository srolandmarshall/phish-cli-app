require_relative '../config/environment.rb'

class Scraper
  TOURS_PAGE ||= "http://phish.net/tour"
  SONGS_PAGE ||= "http://phish.net/song?"
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

  def self.song_has_attr(page, title)
    page.css("table").css("td").any? {|row| row.text.include?("#{title}")}
  end

  def self.song_attr_index(page, title)
    index = page.css("table").css("td").map {|row| row.text.include?("#{title}")}.index(true)
  end

  def self.scrape_song(song)
    attr_titles = ["Original Album", "Appears On", "Music/Lyrics", "Vocals", "Also Known As", "Recommended Versions"]
    page = Nokogiri::HTML(open("http://phish.net#{song.link}/history"))
    lyrics_page = Nokogiri::HTML(open("http://phish.net#{song.link}/history"))
    binding.pry
    song.lyrics = lyrics_page.css("blockquote").text
    song.history = page.css("blockquote.song-history").text
    attr_titles.each do |attrib|
      if song_has_attr(page, attrib)
        index = song_attr_index(page, attrib)
        val = page.css("table").css("td")[index+1]

        song.original_album = val.text if attrib == "Original Album"
        song.musandlyr = val.text if attrib == "Music/Lyrics"
        song.vocals = val.text if attrib ==  "Vocals"
        song.aka = val.text if attrib == "Also Known As"

        if attrib == "Appears On"
          albums = []
          page.css("table").css("td")[index+1].css("img").each do |img|
            albums << img["title"]
          end
          song.appears_on = albums.join(", ")
        end

        if attrib == "Recommended Versions"
          shows = []
          page.css("table").css("td")[index+1].css("a").each do |link|
            shows << link.text
            #eventually make this work with find_by_date to fill this with shows and then have it output their .date_parse
          end
          song.rec_ver = shows.join(", ")
        end

      end
    end

  end

  def scrape_songs
    puts "LOADING SONGS..."
    page = Nokogiri::HTML(open(SONGS_PAGE))
    i=0
    song_rows = page.css("tbody")
    good_songs = song_rows.css("tr:not(.aliases)") & song_rows.css("tr:not(.discography)")
    test_row = []
    begin
      good_songs.each do |row|
        test_row = row
        name = row.css("td")[0].text
        link = row.css('td')[0].css('a')[0]["href"]
        original_artist = row.css('td')[1].text
        times = row.css('td')[2].text
        debut = row.css('td')[3].text
        last = row.css('td')[4].text
        gap = row.css('td')[5].text
        Song.new(name,link,original_artist,times,debut,last,gap)
      end
    rescue NoMethodError
      binding.pry
    end
    # below drags in all song extra info
    # scrape_songs_all
    puts "SONGS LOADED."
  end

  def scrape_songs_all
    puts "EXTENDED SONG INFO LOADING"
    Song.all.each {|song| scrape_song(song)}
    puts "EXTENDED INFO LOADED"
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
      jams << Song.find_by_name(jam.text) if Song.find_by_name(jam.text)
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
    if !Show.show_exist?(date,setlist)
      Show.new(tour, date, venue, location, setlist, notes, rating, jams)
      puts "Scraped #{Show.all.last.date}"
    end
  end

  #date input should always be YYYY-MM-DD
  def self.get_date_page(date)
    divide = date.split("-")
    year = divide[0]
    month = divide[1]
    day = divide[2]
    Nokogiri::HTML(open("http://phish.net/setlists/?year=#{year}&month=#{month}&day=#{day}"))
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
