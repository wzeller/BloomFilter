def randomDeck

diamonds = ["ace",2,3,4,5,6,7,8,9,10,"jack", "queen", "king"]
spades = ["ace",2,3,4,5,6,7,8,9,10,"jack", "queen", "king"]
hearts = ["ace",2,3,4,5,6,7,8,9,10,"jack", "queen", "king"]
clubs = ["ace",2,3,4,5,6,7,8,9,10,"jack", "queen", "king"]

diamonds.each_with_index {|card, index|

diamonds[index] = [card, "diamonds", index+1]

}

spades.each_with_index {|card, index|

spades[index] = [card, "spades", index+1]

}

hearts.each_with_index {|card, index|

hearts[index] = [card, "hearts", index+1]

}

clubs.each_with_index {|card, index|

clubs[index] = [card, "clubs", index+1]

}

deck = diamonds + spades + hearts + clubs

#Generate random numbers to use to shuffle deck.

deckPlacement = (0..51).sort_by{rand}

#Shuffle deck.

deck.each_with_index{|card, index|

	deck[index], deck[deckPlacement[index]] = deck[deckPlacement[index]], deck[index]

}

for card in deck
	puts card[0], card[1]
end

return deck 

end

randomDeck



