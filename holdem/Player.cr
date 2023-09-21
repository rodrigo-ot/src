#Exemplo:
#```
#rodrigo = Player.new
#rodrigo.hand # => []
#```
class Player
    # mão   
    def hand
        @hand
    end

    def dinheiro
        @dinheiro
    end

    #cria um jogador sem cartas
    def initialize(dinheiro = Int32)
        @hand = [] of Card
        @dinheiro = dinheiro
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
end