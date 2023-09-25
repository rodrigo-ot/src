# Exemplo:
#```
#neymar
#```
class PokerGame
    property apostaMinima : Int32
    property deck : Array(Card)
    property players : Array(Player)



    def initialize(players : Int32)
        @deck = createDeck
        @players << Player.new(true)

        #adiciona os bot
        players.times do
            @players << Player.new(false)
        end

    end

    def createDeck()
        deck = [] of Card
        qt = 14
        while qt > 1
            naipe = 3
            while naipe >= 0
                card = Card.new(Suit.new(naipe), qt)
                deck.push(card)
                naipe -= 1
            end
            qt -= 1
        end 
        return deck
    end

    def startGame()
        deck = createDeck.shuffle
        definePlayers()
    end

end