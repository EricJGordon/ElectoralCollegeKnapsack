# ElectoralCollegeKnapsack
Applying the knapsack problem to US elections, to calculate which states could swing the outcome with the fewest additional/changed<sup>1</sup> votes. 

Idea from https://mike.place/2017/ecknapsack/

In many cases like 2016 or the infamous 2000 election, when states are decided by fractions of a percent, it can be relatively straightforward for a casual observer to figure out how the election could have most easily gone the other way, if just a few people had voted differently in certain key states.
However the prevailing narrative doesn't always match up with the mathematically most efficient answer.
Take 2004 as an example. It was 'common knowledge' that the election hinged upon Ohio, where all sorts of factors were at play, including not just your perennial issues like the economy, but also controversies about voting access and voting irregularities, and the inclusion of a concurrent referendum to enshrine a ban on same-sex marriage into the state constitution as a way to increase turnout among conservative voters.

I mention all those details only to point out how easy it can be to get caught up in tha narrative about *which* state really won or lost it for a given candidate, when naturally at the end of the day each electoral vote counts for the same, and there are all sorts of combinations of states that Bush couldn't have won without.

The point of this program is to verify exactly what combination of states Kerry would have needed to swing his way in order to cross the 270 electoral vote threshold, while minimising the number of additional votes that would have been required.

[Brief Complementary (auxiliary?) knapsack explanation]

And so when we do actually run the program on the values from the 2004 election, we see that the most efficient way to change the outcome wouldn't have been flipping Ohio, but in fact would have been flipping New Mexico, Iowa, and Colorado, requiring *only* 115,573 additional votes compared to the 118,601 that would have been needed to flip Ohio.

This would also be useful for elections like 2008 or 1996 where the electoral college victories were so solid that they would have required a considerable number of states to have flipped in order to change the outcome, and therefore way too many combinations to figure out by hand.

1: You can think of this in two main ways, which are essentially equivalent. If a candidate wins a state by 99 votes, in order to flip it the other way you would either need 50 changed voters, from the current winner to the current loser, or 100 extra votes for the current loser.  
I prefer thinking of it in terms of extra voters, because for one, then you don't need to deal with dividing winning margins by two. The main reason though is that it would be equally easy to drop extra voters of a particular party into Pennsylvania as it would to drop them in, say, North Carolina. Both states can be competitive in presidential races, but North Carolina is much less elastic than Pennsylvania.  
My point being that how easy or hard it is to sway voters from one party to another can actually vary from state to state, and I want to make it clear that this isn't a program on where to allocate resources to sway voters and win elections. It looks at it at more of a conceptual level, where 100 additional voters in one state can be considered the same as 100 additional voters in any other. 
