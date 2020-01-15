require 'nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper

  @url = "https://en.wikipedia.org/wiki/2016_United_States_presidential_election"
  @url2 = "https://en.wikipedia.org/w/index.php?title=Template:State_results_of_the_2016_U.S._presidential_election"
  @parsed_page = Nokogiri::HTML(open(@url))

  output = @parsed_page.css(".wikitable")[14].css("tbody").css("tr").css("td").children.map {|child| child.text}

  # print @parsed_page
  puts output[0]
  puts output[26]
  puts output[52]
  print "test"
end