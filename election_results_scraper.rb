require 'Nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper
  url = "https://en.wikipedia.org/wiki/2016_United_States_presidential_election"
  html = Nokogiri::HTML(open(url))
  csv = CSV.open()
end