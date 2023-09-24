#Exemplo:
#```
#rodrigo = Player.new
#rodrigo.hand # => []
#```
class Player
    # mão   
    def isPlayer
        @isPlayer
    end
    def hand
        @hand
    end

    def dinheiro
        @dinheiro
    end

    #cria um jogador sem cartas
    def initialize(dinheiro : Int32, isPlayer : Bool)
        @hand = [] of Card
        @dinheiro = dinheiro
        @isPlayer = isPlayer
    end

    #dá uma carta específica para o jogador
    def give_card(card : Card)
        @hand << card
    end


    # TODO
    def fold
    end

    #TODO
    def call
    end

    #TODO
    def raise
    end


    #verifica se tem carta card na mão e remove
    def remove_card(card : Card)
            if @hand.includes?(card)
                @hand.delete(card)
            end
    end

    def setHand(arr : Array) 
        @hand = arr
    end

    def getHand
        return @hand
    end

    def getReadableHand
        saida = [] of String
        @hand.each do |card|
            saida.push(RANK[card.getRank] + " de " + card.getSuit.to_s())
        end
        return saida
    end
end