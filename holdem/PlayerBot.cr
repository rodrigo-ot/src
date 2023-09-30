class PlayerBot < Player
    T = 1
    
    def chooseAction(jarValue : Int32, contDecisionsBetRaise : Int32, contRemainingPlayers : Int32, contDontChooseFold : Int32, contRaise : Int32)
        #conta para definir a jogada
        decisionBot = (jarValue) / (contDecisionsBetRaise + 1) * contRemainingPlayers * contDontChooseFold * (contRaise + 1)
        if decisionBot < T
            decisionBot = 1
        elsif T <= decisionBot < 20 * T
            decisionBot = 2
        elsif 20 * T <= decisionBot < 50 * T
            decisionBot = 3
        elsif 50 * T <= decisionBot < 100 * T
            decisionBot = 4
        elsif 100 * T <= decisionBot < 1000 * T
            decisionBot = 5
        elsif decisionBot >= 1000 * T
            decisionBot = 6
        end
            
        case decisionBot
        when 1
            #retorna a jogada Fold
            return 1
        when 2
            #retorna a jogada Check
            return 2
        when 3
            #retorna a jogada Bet(Jogada mínima)
            return 3
        when 4
            #retorna a jogada Bet(Jogada mínima * 2)
            return 4
        when 5
            #retorna a jogada Bet(Jogada mínima * 3)
            return 5
        when 6
            #retorna a jogada All-In(Aposta todas as fichas restantes)
            return 6
        end
    end

    def choose_best_cards(community_cards : Array(Card))
        best_cards = [] of Card # Inicializa um array para as melhores cartas
        
        # Classifica as cartas da mesa comunitária
        community_cards = community_cards.sort_by { |card| card.getRank }
      
        # Verifica se há pares, trincas ou quadras na mesa
        ranks_count = Hash(Int32, Int32).new(0)
      
        community_cards.each do |card|
          ranks_count[card.getRank] += 1
        end
      
        # Verifica se há pares, trincas ou quadras na mão do bot
        bot_ranks_count = Hash(Int32, Int32).new(0)
      
        @hand.each do |card|
          bot_ranks_count[card.getRank] += 1
        end
      
        # Escolhe as cartas da mesa que podem formar pares, trincas ou quadras
        community_cards.each do |card|
          if ranks_count[card.getRank] > 1 && bot_ranks_count[card.getRank] < 2
            best_cards << card
          end
        end
      
        # Escolhe as cartas da mesa que podem formar um flush
        suit_count = Hash(Suit, Int32).new(0)
      
        community_cards.each do |card|
          suit_count[card.getSuit] += 1
        end
      
        suit_count.each do |suit, count|
          if count >= 3 # Bot precisa de pelo menos três cartas do mesmo naipe para formar um flush
            flush_cards = community_cards.select { |card| card.getSuit == suit }
            best_cards.concat(flush_cards)
          end
        end
      
        return best_cards
      end
end