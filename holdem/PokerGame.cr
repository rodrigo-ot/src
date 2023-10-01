# Exemplo:
#```
#neymar
#```
class PokerGame
    property apostaMinima : Int32
    property deck : Array(Card)
    property totalPlayers : Array(Player)
    property players : Array(Player)
    property jar : Int32
    property communityCards : Array(Card)
    property maiorAposta = 0

    @@firstMatch = true
    @@terminaJogo = false
    @@contDecisionsBetRaise = 0
    @@contRemainingPlayers = 0
    @@contDontChooseFold = 0
    @@contRaise = 0

    def updateRemainingPlayers
        contRemainingPlayers = @players.size
    end

    def initialize(players : Int32, min : Int32)
        @apostaMinima = min
        @jar = 0
        @deck = createDeck
        @totalPlayers = [] of Player
        @players = [] of Player
        @communityCards = [] of Card
        @totalPlayers << Player.new(true, "Jogador")
        #adiciona os bot
        players.times do |i|
            @totalPlayers << PlayerBot.new(false, "Bot "+ i.to_s)
        end
    end

    def addToJar(qt : Int32)
        @jar += qt
    end

    def setMaiorAposta(aposta)
        @maiorAposta = aposta
    end

    def getMaiorAposta()
        return @maiorAposta
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

    def setDealer()
        unless @@firstMatch
            
            dealer = getDealer
            smallBlind = getSmallBlind
            
            dealer.setFunction(Function::Player)
            smallBlind.setFunction(Function::Dealer)
            puts(smallBlind.getName+" é o Dealer desta rodada.\n")
            indice = @players.index {|player| player.getFunction == Function::Dealer}
            @players.rotate!(indice.to_s.to_i)
            
        else
            puts("Definir papeis")
            #entrega cartas para fazer comparacoes
            deliverCard()

            #dummy
            maior = Player.new(false,"dummy")
            maior.hand << Card.new(Suit.new(0), 0)

            # compara quem tirou a maior carta
            @players.each do |player|
                if player.hand[0].getRank > maior.hand[0].getRank
                    maior = player
                end
            end
            #define quem é o dealer
            maior.setFunction(Function::Dealer)
            puts(maior.getName+" é o Dealer desta rodada.\n")

            # devolve as cartas pro deck
            retrieveCards()
            deck.shuffle

            #organiza o array pro dealer ficar no indice 0
            indice = @players.index {|player| player.getFunction == Function::Dealer}
            @players.rotate!(indice.to_s.to_i)
            @@firstMatch = false
        end
    end

    def getDealer()
        @players.each do |player|
            if player.getFunction == Function::Dealer
                return player
            end
        end
        return @players[0]
    end

    def setSmallBlind()
        dealerIndex = @players.index {|player| player.getFunction == Function::Dealer}
        if dealerIndex.to_s.to_i + 1 < @players.size
            @players[dealerIndex.to_s.to_i+1].setFunction(Function::SmallBlind)
            puts(@players[dealerIndex.to_s.to_i+1].getName+" é o SmallBlind desta rodada.\n")
        end
    end

    

    def setBigBlind()
        dealerIndex = @players.index {|player| player.getFunction == Function::Dealer}
        if dealerIndex.to_s.to_i + 2 < @players.size
            @players[dealerIndex.to_s.to_i+2].setFunction(Function::BigBlind)
            puts(@players[dealerIndex.to_s.to_i+2].getName+" é o BigBlind desta rodada.\n")
        end
    end


    def getSmallBlind
        @players.each do |player|
            if player.getFunction == Function::SmallBlind
                return player
            end
        end
        return @players[0]
    end

    def getBigBlind
        @players.each do |player|
            if player.getFunction == Function::BigBlind
                return player
            end
        end
        return @players[0]
    end

    def deliverCard()
        @players.each do |player|
            player.give_card(@deck.pop)
        end
        puts("Cada jogador recebeu uma carta.\n")
    end
    
    def retrieveCards()
        @players.each do |player|
            deck << player.hand.pop
        end
    end

    def blinds()
        #coloca o dealer no final do array pra facilitar na hora de distribuir cartas
        puts("Blinds\n")
        indice = @players.index {|player| player.getFunction == Function::SmallBlind}
        @players.rotate!(indice.to_s.to_i)
        smallBlind = Player.new(false, "dummy")
        bigBlind = Player.new(false, "dummy")
        @players.each do |player|
            if player.getFunction == Function::SmallBlind
                smallBlind = player
            elsif player.getFunction == Function::BigBlind
                bigBlind = player
            end
        end
        smallBlind.doBet((@apostaMinima/2).to_i)
        addToJar((apostaMinima/2).to_i)
        bigBlind.doBet(apostaMinima)
        addToJar(apostaMinima)
        setMaiorAposta(apostaMinima)
        
        @@contDecisionsBetRaise += 2
    end

    def showControls(bCall : Bool, bRaise : Bool, bFold : Bool, bCheck : Bool)
        info = ""
        if(bCall) 
            info = info+"1 - CALL /"
        end

        if(bRaise)
            info = info+"2 - RAISE /"
        end

        if(bFold)
            info = info+"3 - FOLD /"
        end

        if(bCheck)
            info = info+"4 - CHECK "
        end
        
        info = info +"\n" 
        return info
    end

    def rodadaApostas(bCall : Bool, bRaise : Bool, bFold : Bool, bCheck : Bool)
        @@contRemainingPlayers = @players.size
        @players.each do |player|
            puts("Vez de "+player.getName+"\n")
            #logica de controle
            if !player.is_a?(PlayerBot)
                puts(player.getInfo()+"/ Valor do pote:"+@jar.to_s + " / Maior aposta:"+maiorAposta.to_s)
                puts(showControls(bCall, bRaise, bFold, bCheck))
                playerOption = gets()
                #trata comando
                while true
                    begin
                      case playerOption
                      when "1" # Call
                        if !bCall
                          next
                        end
                        player.doBet(maiorAposta)
                        addToJar(maiorAposta)
                        @@contDecisionsBetRaise += 1
                        @@contDontChooseFold += 1
                  
                      when "2" # Raise
                        if !bRaise
                          next
                        end
                        puts("Em quanto deseja aumentar? / Saldo: #{player.getMoney} / Maior Aposta: #{maiorAposta}")
                        pRaise = gets.to_s.to_i
                        if pRaise <= 0
                          puts("Valor de aumento inválido. Tente novamente.")
                          next
                        end
                        setMaiorAposta(pRaise + maiorAposta)
                        player.doBet(pRaise + maiorAposta)
                        addToJar(pRaise + maiorAposta)
                        @@contDecisionsBetRaise += 1
                        @@contDontChooseFold += 1
                        @@contRaise = pRaise
                  
                      when "3" # Fold
                        if !bFold
                          next
                        end
                        @players.delete(player)
                        puts("#{player.getName} Desistiu da rodada.\n")
                  
                      when "4" # Check
                        if !bCheck
                          next
                        end
                        puts("#{player.getName} Pulou a vez.\n")
                        @@contRemainingPlayers = @players.size
                        @@contDontChooseFold += 1
                        break
                  
                      else
                        raise "Comando inválido"
                      end
                    rescue excecao
                      puts "#{excecao.message}"
                      playerOption = gets.to_s.to_i
                    else
                      break
                    end
                  end
                  
                  

            else
                #logica do bot
                #os bots estao apostando mesmo sem ter dinheiro
                decisao = player.chooseAction(@jar, @@contDecisionsBetRaise, @@contRemainingPlayers, @@contDontChooseFold, @@contRaise)
                case decisao
                when 1
                @players.delete(player)
                puts(player.getName + " Desistiu da rodada.\n")
                when 2
                puts(player.getName + " Pulou a vez.\n")
                @@contDontChooseFold += 1
                when 3
                if player.getMoney >= @apostaMinima
                    player.doBet(@apostaMinima)
                    addToJar(@apostaMinima)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold += 1
                else
                    # Lógica para lidar com o jogador sem dinheiro suficiente para a aposta mínima
                    # Você pode implementar uma ação diferente aqui, como "Desistir" ou "All-in" dependendo das regras do jogo.
                    puts(player.getName + " não tem dinheiro suficiente para a aposta mínima.")
                    # Sugestão: Desistir
                    @players.delete(player)
                end
                when 4
                if player.getMoney >= ((@apostaMinima * 1.25).to_i + @maiorAposta)
                    player.doBet((@apostaMinima * 1.25).to_i + @maiorAposta)
                    setMaiorAposta((@apostaMinima * 1.25).to_i + @maiorAposta)
                    addToJar((@apostaMinima * 1.25).to_i + @maiorAposta)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold += 1
                else
                    # Lógica para lidar com o jogador sem dinheiro suficiente para a aposta desejada
                    # Novamente, você pode implementar uma ação diferente aqui.
                    puts(player.getName + " não tem dinheiro suficiente para a aposta desejada.")
                    # Sugestão: Apostar o máximo que tem
                    player.doBet(player.getMoney)
                    setMaiorAposta(player.getMoney)
                    addToJar(player.getMoney)
                    @@contDecisionsBetRaise += 1
                end
                when 5
                if player.getMoney >= ((@apostaMinima * 1.5).to_i + @maiorAposta)
                    player.doBet((@apostaMinima * 1.5).to_i + @maiorAposta)
                    setMaiorAposta((@apostaMinima * 1.5).to_i + @maiorAposta)
                    addToJar((@apostaMinima * 1.5).to_i + @maiorAposta)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold += 1
                else
                    # Lógica para lidar com o jogador sem dinheiro suficiente para a aposta desejada
                    # Mais uma vez, você pode implementar uma ação diferente aqui.
                    puts(player.getName + " não tem dinheiro suficiente para a aposta desejada.")
                    # Sugestão: Apostar o máximo que tem
                    player.doBet(player.getMoney)
                    setMaiorAposta(player.getMoney)
                    addToJar(player.getMoney)
                    @@contDecisionsBetRaise += 1
                end
                when 6
                if player.getMoney > 0
                    player.doBet(player.getMoney)
                    setMaiorAposta(player.getMoney)
                    addToJar(player.getMoney)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold += 1
                else
                    # Lógica para lidar com o jogador sem dinheiro
                    puts(player.getName + " não tem dinheiro para apostar.")
                    # Sugestão: Desistir
                    @players.delete(player)
                end
                else
                puts("Bug: Decisão inválida")
                end
            end
            @@contRemainingPlayers = @players.size - 1
        end
    end


    def preFlop()
        puts "Pre-Flop:"
        @deck.shuffle
        #entrega 2 cartas para cara jogador na ordem small>big>resto>dealer
        deliverCard()
        deliverCard()
        # coloca o big blind por ultimo
        indice = @players.index {|player| player.getFunction == Function::BigBlind}
        @players.rotate!(indice.to_s.to_i + 1)
        rodadaApostas(true,true,true,false)
    end

    def showCommunityCards(escolher : Bool = false)
        saida = [] of String
        cont = 1
        @communityCards.each do |card|
            if escolher
                saida << cont.to_s + ":" + RANK[card.getRank] + " de " + card.getSuit.to_s()
                cont += 1
            else
                saida << RANK[card.getRank] + " de " + card.getSuit.to_s()
            end

        end
        return saida
    end

    def getCommunityCards
        return @communityCards
    end

    def flop()
        puts "Flop:"
        deck.pop #queima a primeira carta
        communityCards << deck.pop
        communityCards << deck.pop
        communityCards << deck.pop
        puts("Cartas Comunitarias: "+ showCommunityCards.to_s)
        #smallblind joga primeiro nesta rodada
        indice = @players.index {|player| player.getFunction == Function::SmallBlind}
        @players.rotate!(indice.to_s.to_i)
        rodadaApostas(true,true,true,true)
    end

    def turn()
        puts "Turn:"
        deck.pop
        communityCards << deck.pop
        puts("Cartas Comunitarias: "+ showCommunityCards.to_s)
        rodadaApostas(true,true,true,true)
    end

    def river()
        puts "River:"
        deck.pop
        communityCards << deck.pop
        rodadaApostas(true,true,true,true)
    end

    def find_winner() : Player
        winning_player = @players[0] # Inicializa com o primeiro jogador
        best_hand = @players[0].classify_hand() # Classifica a mão do primeiro jogador
      
        @players[1..-1].each do |player|
          player_hand = player.classify_hand()
          if player_hand["value"].to_i > best_hand["value"].to_i ||
             (player_hand["value"].to_i == best_hand["value"].to_i && player_hand["rank"].to_i > best_hand["rank"].to_i)
            winning_player = player
            best_hand = player_hand
          end
        end
      
        return winning_player
      end

      def chooseCards()
        
    end

    def showDown()
        #todo: adicionar verificação se o jogador nao foldou hurdur
        if @players.empty?
            return true
        end
        puts "Showdown:"
        if @players.find { |p| p.is_Player }
            puts "Escolha suas cartas:"
            playerJogadorHumano = @players.find { |p| p.is_Player }
            a = 3
            selected_cards = [] of Card
            
            while a > 0
            puts showCommunityCards(true)
            carta = gets.to_s.to_i
            
            # Verificar se a entrada do jogador é válida
            if carta >= 1 && carta <= @communityCards.size
                selected_card = @communityCards[carta - 1]
                
                # Verificar se a carta já foi escolhida
                if !selected_cards.includes?(selected_card)
                if playerJogadorHumano
                    playerJogadorHumano.give_card(selected_card)
                end
                
                selected_cards << selected_card
                a -= 1
                else
                puts "Você já escolheu esta carta. Escolha outra."
                end
            else
                puts "Opção inválida. Escolha um número entre 1 e #{@communityCards.size}"
            end
            end
        end

        @players.each do |player|
            if player.is_a?(PlayerBot)
                cartas = player.choose_best_cards(getCommunityCards)
                player.hand = player.hand + cartas
            end
            puts player.getName + ": " +player.showHand.to_s + " - " + player.classify_hand["hand"].to_s
        end

        winner = find_winner
        winner.setMoney(@jar + winner.getMoney)
        puts(winner.getName+" venceu esta rodada.")
        puts("continua? s para sim, qualquer coisa para nao")
        continue = gets == "s" ? false : true
        @@terminaJogo = continue
    end
    
    def startGame()
        while true
            @jar = 0
            @deck = createDeck.shuffle
            @players = @totalPlayers.clone
            @communityCards = [] of Card
            setDealer
            setSmallBlind
            setBigBlind
            blinds
            preFlop
            flop
            turn
            river
            showDown
            if @@terminaJogo
                break 
            end
        end
    end
end