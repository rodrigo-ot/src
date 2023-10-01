class PlayerBot < Player
    T = 1
    T1 = 1
    T2 = 20 * T1
    T3 = 50 * T1
    T4 = 100 * T1
    T5 = 1000 * T1
    
    def chooseAction(jarValue : Int32, contDecisionsBetRaise : Int32, contRemainingPlayers : Int32, contDontChooseFold : Int32, contRaise : Int32)
      # Constantes para os limiares de decisão

    
      # Calcula a pontuação de decisão
      decisionScore = (jarValue) / (contDecisionsBetRaise + 1) * contRemainingPlayers * contDontChooseFold * (contRaise + 1)
    
      # Tomada de decisão com base nos limiares
      if decisionScore < T1
        return 1  # Fold
      elsif decisionScore < T2
        return 2  # Check
      elsif decisionScore < T3
        return 3  # Bet (Jogada mínima)
      elsif decisionScore < T4
        return 4  # Bet (Jogada mínima * 2)
      elsif decisionScore < T5
        return 5  # Bet (Jogada mínima * 3)
      else
        return 6  # All-In (Aposta todas as fichas restantes)
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
      
      # Verifica se há pares, trincas ou quadras nas mãos dos bots
      bot_ranks_count = Hash(Int32, Int32).new(0)
      
      @hand.each do |card|
        bot_ranks_count[card.getRank] += 1
      end
      
      # Escolhe as cartas da mesa que podem formar pares, trincas ou quadras,
      # levando em consideração as cartas nas mãos dos bots
      community_cards.each do |card|
        if ranks_count[card.getRank] > 1 && bot_ranks_count[card.getRank] < 2 && best_cards.size < 3
          best_cards << card
        end
      end
      
      # Escolhe as cartas da mesa que podem formar um flush
      suit_count = Hash(Suit, Int32).new(0)
      
      community_cards.each do |card|
        suit_count[card.getSuit] += 1
      end
      
      # Verifica a força das cartas nas mãos dos bots
      bot_rank_strength = Hash(Int32, Int32).new(0)
      
      @hand.each do |card|
        bot_rank_strength[card.getRank] += card.getRank
      end
      
      suit_count.each do |suit, count|
        if count >= 3 && best_cards.size < 3 && bot_rank_strength.any? { |rank, strength| strength >= 12 }
          flush_cards = community_cards.select { |card| card.getSuit == suit }
          flush_cards[0..2].each do |card|
            best_cards << card if best_cards.size < 3
          end
        end
      end
      
      return best_cards
    end
    
end