# ElectoralCollegeKnapsack
Applying the knapsack problem to US elections, to calculate which states could swing the outcome with the fewest additional/changed votes. 

Idea from https://mike.place/2017/ecknapsack/

Note: [explanation of additional vs changed votes]

In many cases like 2016 or the infamous 2000 election, when states are decided by fractions of a percent, it can be relatively straightforward for a casual observer to figure out how the election could most easily have gone the other way, if just a few people had voted differently in certain key states.
However the prevailing narrative doesn't always match up with the mathematically most efficient answer.
Take 2004 as an example. It was 'common knowledge' that the election hinged upon Ohio, where all sorts of factors were at play, including the perennial issue of the economy, controversies about voting access and voting irregularities, and the inclusion of a concurrent referendum to enshrine a ban on same-sex marriage into the state constitution as a way to increase turnout among conservative voters.

I mention all those details only to point out how easy it can be to get caught up in tha narrative about *which* state really won or lost it for a given candidate, when obviously at the end of the day each electoral vote counts for the same, and there are all sorts of combinations of states that Bush couldn't have won without.

The point of this program is to verify exactly what combination of states Kerry would have needed to swing his way in order to cross the 270 electoral vote threshold, while minimising the number of additional votes that would have been required.

[Brief Complementary knapsack explanation]

And so when we do actually run the program on the values from the 2004 election, we see that the most efficient way to change the outcome wouldn't have been flipping Ohio, but in fact would have been flipping New Mexico, Iowa, and Colorado, requiring *only* 115,573 additional votes compared to the 118,601 that would have been needed to flip Ohio.

This would also be useful for elections like 2008 or 1996 where the electoral college victories were so solid that they would have required a considerable number of states to have flipped in order to change the outcome, and therefore way too many combinations to figure out by hand.