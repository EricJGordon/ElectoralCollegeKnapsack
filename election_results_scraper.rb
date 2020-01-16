require 'nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper

  @url = "https://en.wikipedia.org/wiki/2016_United_States_presidential_election"
  @url2 = "https://en.wikipedia.org/w/index.php?title=Template:State_results_of_the_2016_U.S._presidential_election"
  @parsed_page = Nokogiri::HTML(open(@url))

  output = @parsed_page.css(".wikitable")[14].css("tbody").css("tr").css("td").children.map {|child| child.text}

  # print @parsed_page
  55.times do |i|           # 55 from 50 states, plus 2 Maine congressional districts, and 3 Nebraska ones
    puts output[26*i]
    puts output[26*i + 2]
    puts output[26*i + 4]
    puts output[26*i + 5]
    puts output[26*i + 7]
    puts "_______________"
    puts
  end
  # TODO: handle different number of citations per row, currently throwing off pattern of every 26th element

  # print "test"
end