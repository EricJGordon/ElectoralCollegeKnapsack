require 'csv'

table = CSV.parse(File.read("2016results.csv"), converters: :numeric, headers: true)
puts("\nDem total votes: #{table.by_col["D_votes"].sum}")
puts("Rep total votes: #{table.by_col["R_votes"].sum}")

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

def knapsack(items, c)
  chosen = Array.new
  if @solved[items.size][c].nil? && items.size > 0 && c!=0
    #puts items.size
    if items[-1][:weight] > c
      chosen = knapsack(items[0..-2], c)
    else
      #puts("hi #{items[0..-2]}")
      tmp1 = knapsack(items[0..-2], c)
      tmp2 = knapsack(items[0..-2], c - items[-1][:weight])
      tmp2 << items[-1]
      #puts("tmp1:   #{tmp1}")
      #puts("tmp2:   #{tmp2}")
      val1 = tmp1.reduce(0) {|sum, x| sum + x[:value]}
      val2 = tmp2.reduce(0) {|sum, x| sum + x[:value]}
      chosen = val1>val2 ? tmp1 : tmp2
    end
    @solved[items.size][c] = chosen
  end
  chosen
end

item1 = { :name => "foo", :value => 1, :weight => 2 }
item2 = { :name => "bar", :value => 5, :weight => 4 }
item3 = { :name => "bob", :value => 4, :weight => 3 }
item4 = { :name => "jim", :value => 3, :weight => 2 }
item5 = { :name => "joe", :value => 7, :weight => 5 }
item6 = { :name => "tim", :value => 3, :weight => 1 }
items = Array.new
items << item1 << item2 << item3 << item4 << item5 << item6
@solved = Array.new(states.size + 1) {Array.new(269)}

ans = knapsack(states, 268)
puts("Answer: ", ans)
puts("EVs:  #{ans.reduce(0) {|sum, x| sum + x[:weight]}}")
puts("votes needed to scrape a plurality in each of those states:  #{ans.reduce(0) {|sum, x| sum + x[:value]}}")
puts("Comparable number of votes in the states that made up the remaining 270 EVs: #{states.reduce(0) {|sum, x| sum + x[:value]} - ans.reduce(0) {|sum, x| sum + x[:value]}}")
puts("Most efficient states to win EC: ",  states.to_a - ans.to_a)

#print items
# puts
#puts states

