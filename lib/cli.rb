require_relative '../config/environment.rb'

class CommandLineInterface

  HELP_DIALOG = "This is the help dialog.\n\nKEYWORD: Use\n\nHELP: This dialog\nTOUR: Search by tour\nSHOW: Search by show\nSONG: Search by song"
  PROMPT_DIALOG = "Type \'help\' to get a list of commands."
  command_in = false
  scraper = Scraper.new

  def intro
    puts "Welcome to YEMGem , the unofficial Phish Gem."
    puts PROMPT_DIALOG
    command(gets.chomp)
  end

  def repeater
    puts "What would you like to do next?"
    command(gets.chomp)
  end

  def initialize
    intro
  end

  def date_check(date)
    if date == "1985-05-01"
      puts "There were 5 shows this day, none had setlists and it really messes with this program. Nice try,"
      repeater
    else
      page = Scraper.get_date_page(date)
      if page.css("div.bs-callout").text.include?("No shows")
        puts "No shows on this date, try again."
        by_date
      elsif page.css("span.setlist-date").length >= 1
        page.css("span.setlist-date").each do |show|
          Scraper.scrape_show(Nokogiri::HTML(open("http://phish.net#{show.css('a')[1]["href"]}"))) if show.text.include?("PHISH")
        end
        if page.css("span.setlist-date").length == 1
          Show.all.last.display_show
          repeater
        else
          puts "Multiple shows found, choose one:"
          i=1
          shows = Show.all.last(page.css("span.setlist-date").length)
          shows.each do |show|
            puts "#{i}. #{show.date}, #{show.city}"
            i+=1
          end
          show_picker(shows)
        end
      else
        "No Phish shows found on this date, try again"
        by_date
      end
    end
  end


  def by_date
    puts "Enter your date in YYYY-MM-DD (2001-12-31) or MON DD YYYY (Dec 31 2001) format"
    date = gets.chomp
    begin
      Date.parse(date)
    rescue ArgumentError
      if date == "back"
        repeater
      else
        puts "Invalid date, try again"
        puts "******"
        by_date
      end
    else
      date_check(Date.parse(date).to_s)
    end
  end

  def song_menu
    puts "Type the name of the song you'd like to learn more about"
    song = Song.find_by_name(gets.chomp)
    if song
      song.display
    else
      puts "I couldn't find that song. Make sure you spelled it correctly!"
      song_menu
    end
    repeater
  end

  def show_menu
    puts "Do you want to search by date or by tour?"
    input = gets.chomp
    search_by_tour if input.downcase == "tour"
    by_date if input.downcase == "date"
  end

  def yem_egg
    yems = ["What's your fee? Drive me to Firenze.", "You enjoy myself, yes?", "Wash your feet before I drive you to Firenze.", "washa uffize drive me to firenze", "water you team, in a bee-hive, i'm a sent you", "wash, you face, and drive me to Valencia", "Wasohbf woeh ejwro jeeef je ei Fndsbid.", "Watchusett fiji is sun-hived to floor antsy"]
    puts yems.sample
  end

  def stops
    abort("Until the next show!")
  end


  def command(string)
    puts HELP_DIALOG if string.downcase == "help"
    puts "Alpha .1" if string.downcase == "version"
    show_menu if string.downcase == "show"
    song_menu if string.downcase == "song"
    search_by_tour if string.downcase == "tour"
    yem_egg if string.downcase == "yem"
    stops if string.downcase == "stop"
    command(gets.chomp)
  end

  def show_picker(shows)
    puts "Choose the number of the show you'd like to explore."
    choice = gets.chomp
    if choice.to_i <= shows.length
      shows[choice.to_i-1].display_show
      puts "\n"
      repeater
    else
      puts "Invalid show, try again"
      pick_tour(tour)
    end
  end

  def pick_tour(tour)
    tour.display_tour
    show_picker(tour.shows)
  end

  def tour_year(year)
    year_tours = Tour.all.select {|tour| tour.year.include?(year)}
    if year_tours != []
      puts "Tours from #{year}"
      i = 0
      year_tours.each do |tour|
        i+=1
        puts "#{i}. #{tour.name}"
      end
      puts "Type the number of the tour you want to explore, or type \'back\' to go back:"
      entry = false
      while !entry
      explore = gets.chomp
        if (explore.to_i <= year_tours.length)&&(explore.to_i > 0)
          pick_tour(Scraper.scrape_tour(Tour.find_by_name(year_tours[explore.to_i-1].name)))
          entry = true
        else
          puts "Invalid Entry, try again."
        end
      end
    end
    puts "There were no tours this year, please try again." if year_tours == []
    tour_by_year if year_tours == []
  end

  def search_by_tour
    puts "Enter the year you'd like to explore, or type \n'back\' if you want to go back to the main menu:"
    year = gets.chomp
    if (year != "")&&(year.to_i > 1982)&&(year.to_i < 2018)#eventually turn this into check for the current year FUTURE PROOFING
      tour_year(year)
    elsif year == "back"
      intro
    else
      puts "Invalid year, try again."
    end
  end

end
