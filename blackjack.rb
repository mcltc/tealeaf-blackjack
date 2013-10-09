=begin

Blackjack game setup for these conditions:
	3 decks
	Player is shown his/her two cards and only the dealer's up card (2nd card dealt to dealer).
	21 with first two cards (blackjack) always wins unless there is a tie between blackjacks.
	Dealer must hit if total < 17 and stand if total > 17, regardless of player's total.
  
=end

def play(playername)
	deck = shuffledecks

	2.times { 
		playerhand << deck.pop
		dealerhand << deck.pop
	}

	playertotal = get_total(playerhand)
	dealertotal = get_total(dealerhand)

	puts; puts "***DEALING***"
	puts "Your cards are #{ playerhand[0][0] }-#{ playerhand[0][1] } and #{ playerhand[1][0] }-#{ playerhand[1][1] }"
	puts "Your total is #{ playertotal }"
	puts "Dealer's up card is #{ dealerhand[1][0] }-#{ dealerhand[1][1] }"

	if playertotal == 21
		if dealertotal != 21
			puts; puts "Blackjack! #{playername} Wins!"
		else
			puts; puts "Two Blackjacks! Tie!"
		end
	else
		playertotal = playerhit(playerhand, deck, playertotal)

		if playertotal > 21
			puts; puts "#{playername} Busts! Dealer Wins!"
		else
			puts; puts "Dealer's cards are #{ dealerhand[0][0] }-#{ dealerhand[0][1] } and #{ dealerhand[1][0] }-#{ dealerhand[1][1] }"
			puts "Dealer's total is #{ dealertotal }"

			if dealertotal == 21
				puts "Dealer has Blackjack! Dealer Wins!"
			else
				dealertotal = dealerhit(dealerhand, deck, dealertotal)

				if dealertotal > 21
					puts; puts "Dealer Busts! #{playername} Wins!"
				else
					if playertotal > dealertotal
						puts; puts "#{playername} Wins!"
					elsif dealertotal > playertotal
						puts; puts "Dealer Wins!"
					else
						puts; puts "Tie!"
					end
				end	
			end
		end
	end
end


def shuffledecks
	cards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "JACK", "QUEEN", "KING", "ACE"]
	suits = ["SPADES", "DIAMONDS", "HEARTS", "CLUBS"]

	# product method creates an array for each card, i.e. ["JACK", "SPADES"]
	alldecks = cards.product(suits) * 3
	alldecks.shuffle!
	return alldecks
end


def get_total(arrarr)
	# map method takes array of arrays and creates single array of referenced elements
	arr = []
	arr = arrarr.map { |card| card[0] }

	# hash containing card values
	cardvalue = {
		"2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9,
		"10" => 10, "JACK" => 10, "QUEEN" => 10, "KING" => 10, "ACE" => 11
	}

	# calculate total using values from hash
	total = 0
	arr.each { |valuestring| total += cardvalue[valuestring] }

	# count aces
	aces = 0
	arr.each { |valuestring| aces += 1 if valuestring == "ACE" }

	# adjust for aces = 1 instead of aces = 11
	aces.times { total -= 10 if total > 21 }

	return total
end


def playerhit(handarr, deckarr, ptotal)
	puts "Hit or stand? Please enter 'h' for hit or 's' for stand"
	decision = gets.chomp.downcase

	while (decision != "h") && (decision != "s")
		puts "Hit or stand? Please enter 'h' for hit or 's' for stand"
		decision = gets.chomp.downcase
	end

	return ptotal if decision == "s"

	c=2
	while decision == "h"
		handarr << deckarr.pop
		ptotal = get_total(handarr)

		puts; puts "Your new card is #{ handarr[c][0] }-#{ handarr[c][1] }"
		puts "Your new total is #{ ptotal }"

		break if ptotal > 21

		c += 1
		
		puts "Hit or stand? Please enter 'h' for hit or 's' for stand"
		decision = gets.chomp.downcase

		while (decision != "h") && (decision != "s")
			puts "Hit or stand? Please enter 'h' for hit or 's' for stand"
			decision = gets.chomp.downcase
		end
	end

	return ptotal
end


def dealerhit(handarr, deckarr, dtotal)
	c = 2
	while dtotal < 17
		handarr << deckarr.pop
		puts "Dealer's new card is #{ handarr[c][0] }-#{ handarr[c][1] }"

		dtotal = get_total(handarr)
		puts "Dealer's new total is #{ dtotal }"
		break if dtotal > 21
		
		c += 1
	end
	
	return dtotal
end


def again
	puts; puts "Would you like to play again? Please enter 'y' for yes or 'n' for no"
	playagain = gets.chomp.downcase

	while (playagain != "y") && (playagain != "n")
		puts; puts "Would you like to play again? Please enter 'y' for yes or 'n' for no"
		playagain = gets.chomp.downcase
	end

	return true if playagain == "y"
	return false if playagain == "n"
end


puts; puts "Welcome to the blackjack table!"
print "What is your name? "
name = gets.chomp.capitalize
puts; puts "Good Luck #{ name }!"

play(name)

x = again
while x == true
	play(name)
	x = again
end