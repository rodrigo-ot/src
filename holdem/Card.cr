# Exemplo:
#```
#carta = Card.new("Ouro", "K")
#carta.suit # => "Ouro"
#carta.rank # => "K"
#```
#EXPERIMENTAL
class Card
    #Cria uma carta de determinado naipe e numero
    def initialize(suit : Suit, rank : Int32)
        @suit = suit
        @rank = rank
    end

    def suit
        @suit
    end

    def rank
        @rank
    end

    def getSuit
        return @suit
    end
    
    def getRank
        return @rank
    end

end