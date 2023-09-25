#Exemplo:
#```
#rodrigo = Player.new
#rodrigo.hand # => []
#```
class Player
    # mão   
    property isPlayer : Bool
    property hand : Array(Card)
    property dinheiro = 100

    #cria um jogador sem cartas
    def initialize(isPlayer : Bool)
        @hand = [] of Card
        @isPlayer = isPlayer
    end

    #dá uma carta específica para o jogador
    def give_card(card : Card)
        @hand << card
    end


    #verifica se tem carta card na mão e remove
    def remove_card(card : Card)
            if @hand.includes?(card)
                @hand.delete(card)
            end
    end

    def getHand
        return @hand
    end

    def showHand
        saida = [] of String
        @hand.each do |card|
            saida << RANK[card.getRank] + " de " + card.getSuit.to_s()
        end
        return saida
    end
end