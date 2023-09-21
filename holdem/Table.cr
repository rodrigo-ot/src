# Exemplo:
#```
#neymar
#```
class Table
    # Cria uma mesa com os respectivos jogadores no primeio round 
    def initialize(players : Array)
        @rounds = ["Pre-flop","Flop","Turn", "River"]
        @current_round = @rounds[0]
        @players = players.shuffle
    end

    #aposta total
    def jar
        @jar
    end

    def players
        @players = [] of Player
    end

    def rounds
        @rounds = [] of String
    end

    #
    def current_round
        @current_round
    end

    #TODO 
    def skip_round
    end

    #TODO
    def reset_round
    end

end