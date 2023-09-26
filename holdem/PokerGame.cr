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

    def initialize(players : Int32, min : Int32)
        @apostaMinima = min
        @jar = 0
        @deck = createDeck
        @players = [] of Player
        @communityCards = [] of Cards
        @players << Player.new(true, "Jogador")
        #adiciona os bot
        players.times do |i|
            @players << PlayerBot.new(false, "Bot "+ i.to_s)
        end

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
        #entrega cartas para fazer comparacoes
        deliverCard()

        #dummy
        maior = Player.new(false)
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
        @players.rotate!(dealerIndex {|player| player.getFunction == Function::Dealer})
    end

    def getDealer()
        @player.each do |player|
            if player.getFunction == Function::Dealer
                return player
            end
        end
    end

    def setBlinds()
        dealerIndex = @players.dealerIndex {|player| player.getFunction == Function::Dealer}
        if dealerIndex + 1 < @players.size
            @players[dealerIndex+1].setFunction(Function::SmallBlind)
            puts(@players[dealerIndex+1].getName+" é o SmallBlind desta rodada.\n")
        end
        if dealerIndex + 2 < @players.size
            @players[dealerIndex+1].setFunction(Function::BigBlind)
            puts(@players[dealerIndex+1].getName+" é o BigBlind desta rodada.\n")
        end
    end

    def getSmallBlind
        @player.each do |player|
            if player.getFunction == Function::SmallBlind
                return player
            end
        end
    end

    def getBigBlind
        @player.each do |player|
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
            deck << player.hand[0].pop
        end
    end

    def blinds()
        #coloca o dealer no final do array pra facilitar na hora de distribuir cartas
        @players.rotate!
        smallBlind = getSmallBlind
        bigBlind = getBigBlind
        smallBlind.doBet(@apostaMinima/2)
        puts(smallBlind.getName+" realizou a aposta: "+(@apostaMinima/2).to_s+"\n")
        bigBlind.doBet(apostaMinima)
        puts(bigBlind.getName+" realizou a aposta: "+(@apostaMinima).to_s+"\n")
    end

    def preFlop()
        @deck.shuffle
        #entrega 2 cartas para cara jogador na ordem small>big>resto>dealer
        deliverCard()
        deliverCard()

        @player.each do |player|
        # logica de controle
        end
    end

    def flop()

    end

    def turn()

    end

    def river()

    end

    def startGame(min)
        @deck = createDeck.shuffle
        preFlop()
    end

end