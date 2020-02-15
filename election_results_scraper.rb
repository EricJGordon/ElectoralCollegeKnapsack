require 'nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper

  year = 1972
  @url = "https://en.wikipedia.org/wiki/" + year.to_s + "_United_States_presidential_election"
  @parsed_page = Nokogiri::HTML(open(@url))
  table_numbers = { 2016 => 14, 2012 => 6, 2008 => 7, 2004 => 5, 2000 => 5, 1996 => 6, 1992 => 7, 1988 => 7, 1984 => 7, 1980 => 7, 1976 => 5, 1972 => 4}

   output = @parsed_page.css(".wikitable")[table_numbers[year]].css("tbody").css("tr").css("td").children.map(&:text)


  print(output, "\n\n")
  # print @parsed_page

  CSV.open(year.to_s + "results.csv", "wb") do |csv|
    csv << %w(state D_votes R_votes EVs)
    j = 0
    56.times do       # 56 from 50 states, plus Washington DC, plus 2 Maine congressional districts, and 3 Nebraska ones
      row = []
      until output[j][0] =~ /[A-Z]/ && (output[j][1] =~ /[a-z]/ || output[j][1] == ".") # "." for when "D.C." is used instead of full name
        j += 1                                                  # For handling a variable number of citations/blank spaces
        break if output[j].nil?                                 # per row. Skips each one, leaving j at next state's name
      end
      break if output[j].nil?     # TODO: simplify breaks
      row << output[j].delete(',').chomp
      until output[j + 1] =~ /,/         # For handling a variable number of elements between state name and vote numbers
        j += 1                           # due to additional details provided for states that split their electoral votes
      end                                # by congressional district, specifically Maine and Nebraska
      row << output[j + 1].delete(',').chomp  # order of dem/rep votes should be consistent, regardless of wikitable's order,
      row << output[j + 4].delete(',').chomp  # automatically determine by checking header?
      row << (output[j + 3] =~ /[0-9]/ ? output[j + 3].chomp : output[j + 6].chomp)
      csv << row
      j += 1
      # puts "_______________\n"
      break if output[j].nil?
    end
  end
end