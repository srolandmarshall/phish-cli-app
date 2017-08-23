require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url)) # takes the page passed and opens it via open-uri and nokogiri, saves it to page variable.
    student_links = page.css("div").css(".student-card").css("a")
    student_names = page.css("h4").css(".student-name")
    student_locations = page.css("p").css(".student-location")
    students = Array.new()
    i=0
    student_names.each do |student|
      student = {}
      student[:name] = student_names[i].text
      student[:location] = student_locations[i].text
      student[:profile_url] = student_links[i]["href"]
      students<<student
      i+=1
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    profile = {profile_quote: "", bio: ""}
    links = page.css("div").css(".social-icon-container").css("a")
    profile[:profile_quote] = page.css("div").css(".profile-quote").text
    profile[:bio] = page.css("div").css(".description-holder").css("p").text
    links.each do |link|
      profile[:twitter] = link["href"] if link["href"] =~ /twitter/
      profile[:linkedin] = link["href"] if link["href"] =~ /linkedin/
      profile[:github] = link["href"] if link["href"] =~ /github/
      profile[:blog] = link["href"] if link.css("img").attr("src").text =~ /rss/
    end
    profile
  end

end
