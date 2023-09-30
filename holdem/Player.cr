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


    def getMoney()
        return @money
    end

    def is_Player()
        return @isPlayer
    end

    def setMoney(money)
        @money = money
    end

    def getBet()
        return @bet
    end

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

    def setHand(hand)
        @hand = hand
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

    def getInfo()
        return "Sua aposta: " + @bet.to_s + " / Seu saldo: " + @money.to_s + " / Suas cartas: " + showHand.to_s
    end

    def_clone

    def classify_hand()
        hand = @hand.sort_by { |card| card.getRank } # Ordena a mão por rank
      
        is_straight = true
        is_flush = true
        has_pair = false
        has_three_of_a_kind = false
        has_four_of_a_kind = false
        pair_rank = 0
        three_of_a_kind_rank = 0
      
        (0...hand.size - 1).each do |i|
          # Verifica se a mão é um straight (sequência)
          if hand[i].getRank != hand[i + 1].getRank - 1
            is_straight = false
          end
      
          # Verifica se a mão é um flush (mesmo naipe)
          if hand[i].getSuit != hand[i + 1].getSuit
            is_flush = false
          end
      
          # Verifica pares, trincas e quadras
          if hand[i].getRank == hand[i + 1].getRank
            if !has_pair
              has_pair = true
              pair_rank = hand[i].getRank
            elsif hand[i].getRank == pair_rank
              has_three_of_a_kind = true
              three_of_a_kind_rank = hand[i].getRank
            elsif has_three_of_a_kind && hand[i].getRank == three_of_a_kind_rank
              has_four_of_a_kind = true
            end
          end
        end
      
        if is_straight && is_flush
          return { "hand" => "Straight Flush", "value" => 9, "rank" => hand[-1].getRank }
        elsif has_four_of_a_kind
          return { "hand" => "Quadra", "value" => 8, "rank" => pair_rank }
        elsif has_three_of_a_kind && has_pair
          return { "hand" => "Full House", "value" => 7, "rank" => three_of_a_kind_rank }
        elsif is_flush
          return { "hand" => "Flush", "value" => 6, "rank" => hand[-1].getRank }
        elsif is_straight
          return { "hand" => "Straight", "value" => 5, "rank" => hand[-1].getRank }
        elsif has_three_of_a_kind
          return { "hand" => "Trinca", "value" => 4, "rank" => three_of_a_kind_rank }
        elsif has_pair
          if has_pair && has_three_of_a_kind
            return { "hand" => "Dois Pares", "value" => 3, "rank" => three_of_a_kind_rank }
          else
            return { "hand" => "Par", "value" => 2, "rank" => pair_rank }
          end
        else
          return { "hand" => "Carta Alta", "value" => 1, "rank" => hand[-1].getRank }
        end
    end
      
    
    def doBet(aposta : Int32)
        begin
            if aposta <= @money
                @bet = aposta
                @money -= aposta
                puts(getName()+" realizou a aposta: "+(aposta).to_s+"\n")
            return aposta
            else
                raise Exception.new("Não tem dinheiro suficiente! Tentativa: "+aposta.to_s()+" Saldo disponivel: "+@money.to_s())
            end
        rescue excecao
            puts "#{excecao.message}"
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