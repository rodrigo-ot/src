require "./holdem/Card.cr"
require "./holdem/Player.cr"
require "./holdem/enums/suit.cr"
require "./holdem/enums/rank.cr"

# rodrigo = Player.new

# rodrigo.give_card(carta)

# puts(rodrigo.hand[0].number)
def createPlayers(q, money)
    players = [] of Player

    while q > 0
        players.push(Player.new(money))
        q -= 1
    end
    return players
end

def createDeck()
    deck = [] of Card
    qt = 13
    while qt > 1
        naipe = 3
        while naipe >= 0
            card = Card.new(Suit.new(naipe), qt)
            deck.push(card)
            naipe -= 1
        end
        qt -= 1
    end 
    return deck.shuffle
end

def startGame(qtOponentes, dificuldade, money)
    players = createPlayers(qtOponentes, money)

    shuffle
    puts players
    table = new table(players)

end


