# Exemplo:
#```
#neymar
#```
class PokerGame
    property apostaMinima : Int32
    property deck : Array(Card)
    property players : Array(Player)
    property jar : Int32
    property communityCards : Array(Card)
    property maiorAposta = 0

    @@contDecisionsBetRaise = 1
    @@contRemainingPlayers = 1
    @@contDontChooseFold = 1
    @@contRaise = 1

    def updateRemainingPlayers
        contRemainingPlayers = @players.size
    end


    def initialize(players : Int32, min : Int32)
        @apostaMinima = min
        @jar = 0
        @deck = createDeck
        @players = [] of Player
        @communityCards = [] of Card
        @players << Player.new(true, "Jogador")
        #adiciona os bot
        players.times do |i|
            @players << PlayerBot.new(false, "Bot "+ i.to_s)
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
    end

    def getDealer()
        @players.each do |player|
            if player.getFunction == Function::Dealer
                return player
            end
        end
    end

    def setBlinds()
        dealerIndex = @players.index {|player| player.getFunction == Function::Dealer}
        if dealerIndex.to_s.to_i + 1 < @players.size
            @players[dealerIndex.to_s.to_i+1].setFunction(Function::SmallBlind)
            puts(@players[dealerIndex.to_s.to_i+1].getName+" é o SmallBlind desta rodada.\n")
        end
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
    end

    def getBigBlind
        @players.each do |player|
            if player.getFunction == Function::BigBlind
                return player
            end
        end
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
                        when "1" #call
                            if bCall == false
                                next
                            end
                            player.doBet(maiorAposta)
                            addToJar(maiorAposta)
                            @@contDecisionsBetRaise += 1
                            @@contDontChooseFold += 1
                            
                        when "2" #raise
                            if bRaise == false
                                next
                            end
                            puts("Em quanto deseja aumentar? / Saldo:"+player.getMoney.to_s+"/ Maior Aposta:"+maiorAposta.to_s)
                            pRaise = gets()
                            setMaiorAposta(pRaise.to_s.to_i + maiorAposta)
                            player.doBet(pRaise.to_s.to_i + maiorAposta)
                            addToJar(pRaise.to_s.to_i + maiorAposta)
                            @@contDecisionsBetRaise += 1
                            @@contDontChooseFold +=1
                            @@contRaise = pRaise.to_s.to_i
                            
                            # puts(player.getName+" Aumentou a aposta para:"+(pRaise.to_s.to_i + maiorAposta).to_s)
                        when "3" #fold
                            if bFold == false
                                next
                            end
                            @players.delete(player)
                            puts(player.getName+" Desistiu da rodada.\n")
                        when "4" #check
                            if bCheck == false
                                next
                            end
                            puts(player.getName+" Pulou a vez.\n")
                            @@contRemainingPlayers = @players.size
                            @@contDontChooseFold += 1
                            break
                        else
                            raise Exception.new("Comando inválido")
                        end
                    rescue excecao
                        puts "#{excecao.message}"
                        playerOption = gets()
                    else
                        break
                    end
                end

            else
                #logica do bot
                decisao = player.chooseAction(@jar,@@contDecisionsBetRaise, @@contRemainingPlayers, @@contDontChooseFold, @@contRaise)
                case decisao
                when 1
                    @players.delete(player)
                    puts(player.getName+" Desistiu da rodada.\n")
                when 2
                    puts(player.getName+" Pulou a vez.\n")
                    @@contDontChooseFold +=1
                    break
                when 3
                    player.doBet(@apostaMinima)
                    addToJar(@apostaMinima)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold +=1
                when 4
                    player.doBet((@apostaMinima*1.25).to_i+@maiorAposta)
                    setMaiorAposta((@apostaMinima*1.25).to_i+@maiorAposta)
                    addToJar(@apostaMinima*1.25.to_i+@maiorAposta)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold +=1
                when 5
                    player.doBet((@apostaMinima*1.5).to_i+@maiorAposta)
                    setMaiorAposta((@apostaMinima*1.25).to_i+@maiorAposta)
                    addToJar(@apostaMinima*1.5.to_i+@maiorAposta)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold +=1
                when 6
                    player.doBet(player.getMoney)
                    setMaiorAposta(player.getMoney)
                    addToJar(player.getMoney)
                    @@contDecisionsBetRaise += 1
                    @@contDontChooseFold +=1
                else
                    puts("bug")
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

    def showCommunityCards
        saida = [] of String
        @communityCards.each do |card|
            saida << RANK[card.getRank] + " de " + card.getSuit.to_s()
        end
        return saida
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

    def showDown()
        puts "Showdown:"

        
        # Mostra as cartas de cada jogador
        @players.each do |player|
            puts(player.getName+"Tem as cartas: "+player.showHand.to_s+showCommunityCards.to_s)
        end
        
        # Lógica para determinar o vencedor
        # Implemente sua lógica aqui com base nas combinações de cartas
        
        # Exemplo: Vencedor é o jogador com a maior carta mais 
        
    end

    def startGame()
        @deck = createDeck.shuffle
        setDealer
        setBlinds
        blinds
        preFlop
        flop
        turn
        river
        showDown
    end

end