require 'csv'

table = CSV.parse(File.read("2016results.csv"), converters: :numeric, headers: true)
puts("\nDem total votes: #{table.by_col["D_votes"].sum}")
puts("Rep total votes: #{table.by_col["R_votes"].sum}")
puts "(currently double counting Maine and Nebraska)"

states = Array.new

dem_EVs, rep_EVs = 0, 0
table.each do |row|
  dem_EVs += row["EVs"] if row["D_votes"] > row["R_votes"]
  rep_EVs += row["EVs"] if row["R_votes"] > row["D_votes"]

  states << {name: row["state"], weight: row["EVs"], value: (row["D_votes"]+row["R_votes"]) / 2 + 1}
end

puts("\nDem electoral votes: #{dem_EVs}")
puts("Rep electoral votes: #{rep_EVs}")
puts("Winner is the #{(dem_EVs>rep_EVs)?"Democrat":"Republican"}")

def knapsack(items, weight)
  chosen = Array.new
  0.upto(items.size) do |i|
    0.upto(weight) do |w|
      if i == 0 || w == 0
        @solved[i][w] = 0
      elsif items[i - 1][:weight] <= w
        @solved[i][w] = [@solved[i - 1][w], @solved[i - 1][w - items[i - 1][:weight]] + items[i - 1][:value]].max
      else
        @solved[i][w] = @solved[i - 1][w];
      end
    end
  end
  items.length.downto(0) do |i|
    if @solved[i][weight] != @solved[i - 1][weight]
        weight -= items[i - 1][:weight]
    chosen << items[i - 1]
    end
  end
  chosen
end

@solved = Array.new(states.size + 1) {Array.new(269)}

#puts states
ans = knapsack(states.shuffle, 268)
puts("\nOutput: ", ans)
puts("EVs:  #{ans.reduce(0) {|sum, x| sum + x[:weight]}}")
puts("Votes needed to scrape a plurality in each of those states:  #{ans.reduce(0) {|sum, x| sum + x[:value]}}")
min_votes = states.reduce(0) {|sum, x| sum + x[:value]} - ans.reduce(0) {|sum, x| sum + x[:value]}
puts("Comparable number of votes in the states that made up the remaining 270 EVs: #{min_votes}")
puts("As a percentage of the total vote, that would be #{(min_votes.to_f/(table.by_col["D_votes"].sum + table.by_col["R_votes"].sum)*100).round(2)}% ")
puts("\nMost efficient states to win EC: ",  (states.to_a - ans.to_a).map { |s| "#{s[:value]} votes in #{s[:name]}" })

