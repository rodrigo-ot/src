#Exemplo:
#```
#rodrigo = Player.new
#rodrigo.hand # => []
#```
class Player
    # mão   
    property isPlayer : Bool
    property hand : Array(Card)
    property money = 100
    property bet = 0
    property name : String


    def function : Function
        @function
    end

    #cria um jogador sem cartas
    def initialize(isPlayer : Bool, name : String)
        @name = name
        @hand = [] of Card
        @isPlayer = isPlayer
        @function = Function::Player
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

    
    def getName
        return @name+" ("+@function.to_s+")"
    end

    def getHand
        return @hand
    end

    def setFunction(function : Function)
        @function = function
    end

    def getFunction
        return @function
    end

    def doBet(aposta : Int32)
        if aposta <= @money
            @bet = aposta
            return aposta
        else
            puts("Não tem dinheiro suficiente! Tentativa: "+aposta.to_s()+" Saldo disponivel: "+@money.to_s())
        end
        return -1
    end

    def showHand
        saida = [] of String
        @hand.each do |card|
            saida << RANK[card.getRank] + " de " + card.getSuit.to_s()
        end
        return saida
    end
end